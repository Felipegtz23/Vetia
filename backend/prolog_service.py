
from __future__ import annotations

import re
import threading
from pathlib import Path
from typing import Any

from swiplserver import PrologMQI


ATOM_PATTERN = re.compile(r"^[a-z][a-z0-9_]*$")


class PrologServiceError(RuntimeError):
    """Error de comunicación o consulta con SWI-Prolog."""


def _atom(value: str) -> str:
    """Valida identificadores antes de incorporarlos a una consulta."""
    if not isinstance(value, str) or not ATOM_PATTERN.fullmatch(value):
        raise ValueError(f"Identificador Prolog no válido: {value!r}")
    return value


def _compound(value: Any, functor: str | None = None) -> list:
    """Extrae los argumentos de un término compuesto de swiplserver."""
    if not isinstance(value, dict) or "args" not in value:
        raise PrologServiceError(f"Término Prolog inesperado: {value!r}")

    if functor is not None and value.get("functor") != functor:
        raise PrologServiceError(f"Se esperaba {functor}: {value!r}")

    return value["args"]


class PrologService:

    def __init__(self) -> None:
        self.root = Path(__file__).resolve().parents[1]
        self.vetia_file = self.root / "prolog" / "Vetia.pl"

        if not self.vetia_file.is_file():
            raise FileNotFoundError(
                f"No se encontró el motor Prolog: {self.vetia_file}"
            )

        self._lock = threading.RLock()
        self._mqi = PrologMQI()
        self._mqi.__enter__()

        try:
            self._thread = self._mqi.create_thread()
            self._thread.__enter__()

            prolog_path = self.vetia_file.as_posix().replace("'", "\\'")
            result = self._query(
                f"consult('{prolog_path}')"
            )

            if result is not True:
                raise PrologServiceError("No se pudo cargar VetIA.pl")

        except Exception:
            self.close()
            raise

    def close(self) -> None:
        thread = getattr(self, "_thread", None)
        mqi = getattr(self, "_mqi", None)

        if thread is not None:
            try:
                thread.__exit__(None, None, None)
            except Exception:
                pass
            self._thread = None

        if mqi is not None:
            try:
                mqi.__exit__(None, None, None)
            except Exception:
                pass
            self._mqi = None

    def _query(self, query: str) -> Any:
        try:
            with self._lock:
                return self._thread.query(query)
        except Exception as exc:
            raise PrologServiceError(
                f"Error ejecutando consulta Prolog: {exc}"
            ) from exc

    def _one(self, query: str) -> dict:
        results = self._query(query)

        if not results:
            return {}

        return results[0]

    def _list(self, query: str, variable: str) -> list:
        result = self._one(query)
        return result.get(variable, [])

    def _name(self, disease: str) -> str:
        disease = _atom(disease)

        result = self._one(
            f"nombre_mostrado({disease}, Nombre)"
        )

        return str(result.get("Nombre", disease))

    def _symptom_metadata(self, symptom: str) -> dict:
        symptom = _atom(symptom)

        label = self._one(
            f"(etiqueta_sintoma({symptom}, E) -> true ; E = {symptom})"
        ).get("E", symptom)

        category = self._one(
            f"(categoria_sintoma({symptom}, C) -> true ; C = desconocida)"
        ).get("C", "desconocida")

        system = self._one(
            f"(sistema_sintoma({symptom}, S) -> true ; S = sin_clasificar)"
        ).get("S", "sin_clasificar")

        return {
            "id": symptom,
            "nombre": str(label),
            "categoria": str(category),
            "sistema": str(system),
        }

    def health(self) -> dict:
        result = self._one("listar_enfermedades(E)")

        return {
            "status": "ok",
            "prolog": "connected",
            "enfermedades_registradas": len(result.get("E", [])),
        }

    def enfermedades(self) -> list:
        identifiers = self._list(
            "listar_enfermedades(E)",
            "E"
        )

        return [
            {
                "id": disease,
                "nombre": self._name(disease),
            }
            for disease in identifiers
        ]

    def sintomas(self) -> list:
        identifiers = self._list(
            "findall(S, sintoma_de(S, _), L), sort(L, S), Sintomas = S",
            "Sintomas",
        )

        return [
            self._symptom_metadata(symptom)
            for symptom in identifiers
        ]

    def pruebas(self) -> list:
        identifiers = self._list(
            "findall(P, prueba_asociada(P, _), L), sort(L, P), Pruebas = P",
            "Pruebas",
        )

        return [
            {
                "id": item,
                "nombre": item.replace("_", " ").capitalize()
            }
            for item in identifiers
        ]

    @staticmethod
    def _observations(
        presentes: list[str],
        ausentes: list[str],
    ) -> str:
        terms = []

        for symptom in presentes:
            terms.append(f"presente({_atom(symptom)})")

        for symptom in ausentes:
            terms.append(f"ausente({_atom(symptom)})")

        return "[" + ",".join(terms) + "]"

    def _observations_analysis(self, observations: str) -> dict:
        result = self._one(
            "observaciones_analizadas("
            f"{observations}, P, A, D, C)"
        )

        return {
            "presentes": result.get("P", []),
            "ausentes": result.get("A", []),
            "desconocidos": result.get("D", []),
            "contradictorios": result.get("C", []),
        }

    def _ranking(self, observations: str) -> list:
        ranking = self._list(
            f"ranking_diagnosticos({observations}, R)",
            "R",
        )

        parsed = []

        for item in ranking:
            outer = _compound(item, "-")
            score_and_disease = _compound(outer[0], "-")

            parsed.append({
                "coincidencias": int(score_and_disease[0]),
                "enfermedad": str(score_and_disease[1]),
                "sintomas": list(outer[1]),
            })

        return parsed

    def _rule_details(
        self,
        observations: str,
        disease: str,
    ) -> list:
        disease = _atom(disease)

        rules = self._list(
            f"reglas_de_enfermedad({observations}, {disease}, R)",
            "R",
        )

        parsed = []

        for rule in rules:
            args = _compound(rule, "regla_disparada")

            (
                rule_id,
                rule_disease,
                premises,
                conclusion,
                justification,
                source_id,
            ) = args

            source = self._one(
                f"(fuente_conocimiento({source_id}, Ref) "
                f"-> true ; Ref = {source_id})"
            ).get("Ref", source_id)

            parsed.append({
                "id": str(rule_id),
                "enfermedad": str(rule_disease),
                "premisas": list(premises),
                "conclusion": str(conclusion),
                "justificacion": str(justification),
                "fuente_id": str(source_id),
                "fuente": str(source),
            })

        return parsed

    def _sources_for_symptom(
        self,
        symptom: str,
        disease: str,
    ) -> list:
        symptom = _atom(symptom)
        disease = _atom(disease)

        result = self._one(
            f"findall(F, fuente_signo({symptom}, {disease}, F), L), "
            "sort(L, Fuentes)"
        )

        source_ids = result.get("Fuentes", [])
        sources = []

        for source_id in source_ids:
            source = self._one(
                f"(fuente_conocimiento({source_id}, Ref) "
                f"-> true ; Ref = {source_id})"
            ).get("Ref", source_id)

            sources.append({
                "id": str(source_id),
                "referencia": str(source),
            })

        return sources

    def _hypothesis(
        self,
        observations: str,
        item: dict,
    ) -> dict:
        disease = _atom(item["enfermedad"])

        coincidences = self._list(
            f"coincidencias({observations}, {disease}, C)",
            "C",
        )

        registered = self._list(
            f"sintomas_registrados({disease}, S)",
            "S",
        )

        percentage_result = self._one(
            f"porcentaje_coincidencia("
            f"{len(coincidences)}, {len(registered)}, P)"
        )

        percentage = percentage_result.get("P", 0)

        classified = self._one(
            f"clasificar_coincidencias({coincidences}, I, O)"
        )

        orientative = classified.get("O", [])
        nonspecific = classified.get("I", [])

        tests = self._list(
            f"coincidencias_pruebas({observations}, {disease}, P)",
            "P",
        )

        missing = self._list(
            f"sintomas_no_reportados({observations}, {disease}, F)",
            "F",
        )

        absent = self._list(
            f"sintomas_ausentes_registrados({observations}, {disease}, A)",
            "A",
        )

        rules = self._rule_details(observations, disease)

        return {
            "enfermedad": {
                "id": disease,
                "nombre": self._name(disease),
            },
            "coincidencias": len(coincidences),
            "total_sintomas_registrados": len(registered),
            "porcentaje_coincidencia": percentage,
            "interpretacion_porcentaje": (
                "Cobertura de síntomas registrados; no representa "
                "una probabilidad clínica."
            ),
            "sintomas_coincidentes": [
                self._symptom_metadata(s) for s in coincidences
            ],
            "sintomas_orientativos": [
                self._symptom_metadata(s) for s in orientative
            ],
            "sintomas_inespecificos": [
                self._symptom_metadata(s) for s in nonspecific
            ],
            "pruebas_coincidentes": tests,
            "sintomas_no_reportados": missing,
            "sintomas_ausentes": absent,
            "reglas_activadas": rules,
            "fuentes_por_sintoma": [
                {
                    "sintoma": symptom,
                    "fuentes": self._sources_for_symptom(
                        symptom, disease
                    ),
                }
                for symptom in coincidences
            ],
        }

    def diagnosticar(
        self,
        presentes: list[str],
        ausentes: list[str],
    ) -> dict:
        observations = self._observations(presentes, ausentes)

        analysis = self._observations_analysis(observations)
        ranking = self._ranking(observations)

        top = ranking[:3]

        hypotheses = [
            self._hypothesis(observations, item)
            for item in top
        ]

        all_rules = self._list(
            f"reglas_activadas({observations}, R)",
            "R",
        )

        top_diseases = {
            item["enfermedad"]["id"]
            for item in hypotheses
        }

        outside_top = []

        for rule in all_rules:
            args = _compound(rule, "regla_disparada")
            disease = str(args[1])

            if disease not in top_diseases:
                outside_top.append(disease)

        tie_count = 0

        if len(top) == 3:
            cutoff = top[-1]["coincidencias"]

            tie_count = sum(
                1 for item in ranking[3:]
                if item["coincidencias"] == cutoff
            )

        return {
            "estado": (
                "sin_coincidencias" if not ranking else "evaluado"
            ),
            "observaciones": analysis,
            "total_hipotesis": len(ranking),
            "hipotesis": hypotheses,
            "empate_en_limite_top_3": tie_count,
            "reglas_activadas_fuera_del_top_3": sorted(
                set(outside_top)
            ),
            "nota": (
                "Las hipótesis indican compatibilidad con los hallazgos "
                "registrados. No constituyen diagnósticos confirmados."
            ),
        }

    # ---------------------------------------------------------
    # DETALLE INDIVIDUAL DE UNA ENFERMEDAD
    # ---------------------------------------------------------

    def detalle_enfermedad(self, disease_id: str) -> dict:
        disease = _atom(disease_id)

        enfermedades = self._list(
            "listar_enfermedades(E)",
            "E",
        )

        if disease not in enfermedades:
            raise ValueError(
                "La enfermedad solicitada no está registrada."
            )

        sintomas = self._list(
            f"sintomas_registrados({disease}, S)",
            "S",
        )

        pruebas = self._list(
            f"pruebas_registradas({disease}, P)",
            "P",
        )

        fuentes = self._list(
            f"findall(Referencia, "
            f"(fuente_signo(_, {disease}, FuenteId), "
            f"fuente_conocimiento(FuenteId, Referencia)), "
            f"Lista), sort(Lista, Fuentes)",
            "Fuentes",
        )

        return {
            "id": disease,
            "nombre": self._name(disease),
            "sintomas": [
                self._symptom_metadata(sintoma)
                for sintoma in sintomas
            ],
            "pruebas": [
                self._symptom_metadata(prueba)
                for prueba in pruebas
            ],
            "fuentes": fuentes,
        }
