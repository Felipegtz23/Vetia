
import { useEffect, useRef, useState } from "react";
import {
  Activity,
  AlertCircle,
  CheckCircle2,
  ChevronRight,
  Database,
  HeartPulse,
  LoaderCircle,
  PawPrint,
  RefreshCw,
  Search,
  ShieldCheck,
  Stethoscope,
} from "lucide-react";

import {
  getHealth,
  getSymptoms,
  getDiseases,
  getDiseaseDetails,
  diagnose,
} from "../services/diagnosisService";

import type {
  DiagnosisResponse,
  Symptom,
  Disease,
  Hypothesis,
  DiseaseDetails,
} from "../types/diagnosis";

type Section = "diagnostico" | "conocimiento";

export default function Dashboard() {
  const [section, setSection] = useState<Section>("diagnostico");
  const [symptoms, setSymptoms] = useState<Symptom[]>([]);
  const [diseases, setDiseases] = useState<Disease[]>([]);
  const [presentSymptoms, setPresentSymptoms] = useState<string[]>([]);
  const [absentSymptoms, setAbsentSymptoms] = useState<string[]>([]);
  const [result, setResult] = useState<DiagnosisResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [analyzing, setAnalyzing] = useState(false);
  const [error, setError] = useState("");
  const [backendStatus, setBackendStatus] = useState("Comprobando...");
  const [search, setSearch] = useState("");

  // Estado del registro de conocimiento
  const [selectedDiseaseId, setSelectedDiseaseId] = useState<string | null>(
    null
  );
  const [selectedDisease, setSelectedDisease] =
    useState<DiseaseDetails | null>(null);
  const [diseaseDetailLoading, setDiseaseDetailLoading] = useState(false);
  const [diseaseDetailError, setDiseaseDetailError] = useState("");

  // Referencia del único contenedor desplazable del modal
  const modalScrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    loadData();
  }, []);

  // Bloqueo del fondo, cierre con Escape y reinicio del scroll al abrir
  useEffect(() => {
    if (!selectedDiseaseId) return;

    document.body.classList.add("modal-open");

    if (modalScrollRef.current) {
      modalScrollRef.current.scrollTop = 0;
    }

    function handleEscape(event: KeyboardEvent) {
      if (event.key === "Escape") {
        closeDiseaseDetails();
      }
    }

    document.addEventListener("keydown", handleEscape);

    return () => {
      document.removeEventListener("keydown", handleEscape);
      document.body.classList.remove("modal-open");
    };
  }, [selectedDiseaseId]);

  async function loadData() {
    setLoading(true);
    setError("");

    try {
      const [health, symptomData, diseaseData] = await Promise.all([
        getHealth(),
        getSymptoms(),
        getDiseases(),
      ]);

      setBackendStatus(
        health.prolog === "connected"
          ? "Prolog conectado"
          : "Prolog desconectado"
      );

      setSymptoms(symptomData);
      setDiseases(diseaseData);
    } catch (err) {
      setBackendStatus("Sin conexión");
      setError(
        err instanceof Error
          ? err.message
          : "No fue posible conectar con VetIA."
      );
    } finally {
      setLoading(false);
    }
  }

  // Consultar la ficha completa de una enfermedad
  async function openDiseaseDetails(disease: Disease) {
    setSelectedDiseaseId(disease.id);
    setSelectedDisease(null);
    setDiseaseDetailError("");
    setDiseaseDetailLoading(true);

    try {
      const details = await getDiseaseDetails(disease.id);
      setSelectedDisease(details);
    } catch (err) {
      setDiseaseDetailError(
        err instanceof Error
          ? err.message
          : "No fue posible cargar la información de esta enfermedad."
      );
    } finally {
      setDiseaseDetailLoading(false);
    }
  }

  // Cerrar la ficha de conocimiento
  function closeDiseaseDetails() {
    setSelectedDiseaseId(null);
    setSelectedDisease(null);
    setDiseaseDetailError("");
    setDiseaseDetailLoading(false);
  }

  function toggleSymptom(id: string, type: "present" | "absent") {
    setResult(null);
    setError("");

    if (type === "present") {
      setPresentSymptoms((previous) =>
        previous.includes(id)
          ? previous.filter((item) => item !== id)
          : [...previous, id]
      );

      setAbsentSymptoms((previous) =>
        previous.filter((item) => item !== id)
      );
    } else {
      setAbsentSymptoms((previous) =>
        previous.includes(id)
          ? previous.filter((item) => item !== id)
          : [...previous, id]
      );

      setPresentSymptoms((previous) =>
        previous.filter((item) => item !== id)
      );
    }
  }

  async function handleDiagnosis() {
    if (presentSymptoms.length === 0 && absentSymptoms.length === 0) {
      setError("Selecciona al menos un síntoma presente o ausente.");
      return;
    }

    setAnalyzing(true);
    setError("");
    setResult(null);

    try {
      const response = await diagnose(presentSymptoms, absentSymptoms);
      setResult(response);
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : "No se pudo realizar la evaluación."
      );
    } finally {
      setAnalyzing(false);
    }
  }

  function resetDiagnosis() {
    setPresentSymptoms([]);
    setAbsentSymptoms([]);
    setResult(null);
    setError("");
  }

  const systems = Array.from(
    new Set(symptoms.map((symptom) => symptom.sistema))
  );

  const filteredDiseases = diseases.filter((disease) =>
    disease.nombre.toLowerCase().includes(search.toLowerCase())
  );

  function HypothesisCard({
    hypothesis,
    index,
  }: {
    hypothesis: Hypothesis;
    index: number;
  }) {
    const percentage = Math.min(
      100,
      Math.max(0, hypothesis.porcentaje_coincidencia)
    );

    return (
      <article className="mb-5 rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-6">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="text-[9px] font-bold uppercase tracking-wider text-[#665E58]">
              HIPÓTESIS {index + 1}
            </p>

            <h3 className="mt-2 font-heading text-lg font-bold">
              {hypothesis.enfermedad.nombre}
            </h3>

            <p className="mt-1 text-xs text-[#665E58]">
              {hypothesis.enfermedad.id}
            </p>
          </div>

          <span className="rounded-full bg-[#F1E7E2] px-3 py-2 text-xs font-bold text-[#8F514A]">
            {hypothesis.coincidencias} coincidencias
          </span>
        </div>

        <div className="mt-5 rounded-xl bg-[#FFFFFF] p-4">
          <div className="flex items-center justify-between gap-3">
            <p className="text-xs font-bold">
              Cobertura de síntomas registrados
            </p>
            <span className="text-sm font-bold">{percentage}%</span>
          </div>

          <div className="mt-3 h-2 overflow-hidden rounded-full bg-[#E8E1DB]">
            <div
              className="h-full rounded-full bg-[#3D302C]"
              style={{ width: `${percentage}%` }}
            />
          </div>

          <p className="mt-2 text-[10px] leading-5 text-[#665E58]">
            {hypothesis.interpretacion_porcentaje}
          </p>
        </div>

        <div className="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-2">
          <div>
            <p className="text-xs font-bold text-[#3D302C]">
              Síntomas coincidentes
            </p>

            <ul className="mt-3 space-y-2">
              {hypothesis.sintomas_coincidentes.map((symptom) => (
                <li key={symptom.id} className="text-xs text-[#665E58]">
                  • {symptom.nombre}
                </li>
              ))}

              {hypothesis.sintomas_coincidentes.length === 0 && (
                <li className="text-xs text-[#665E58]">
                  Sin coincidencias.
                </li>
              )}
            </ul>
          </div>

          <div>
            <p className="text-xs font-bold text-[#3D302C]">
              Síntomas no reportados
            </p>

            <ul className="mt-3 space-y-2">
              {hypothesis.sintomas_no_reportados.map((symptom) => (
                <li key={symptom} className="text-xs text-[#665E58]">
                  • {symptom}
                </li>
              ))}

              {hypothesis.sintomas_no_reportados.length === 0 && (
                <li className="text-xs text-[#665E58]">Ninguno.</li>
              )}
            </ul>
          </div>

          <div>
            <p className="text-xs font-bold text-[#3D302C]">
              Síntomas orientativos
            </p>

            <ul className="mt-3 space-y-2">
              {hypothesis.sintomas_orientativos.map((symptom) => (
                <li key={symptom.id} className="text-xs text-[#665E58]">
                  • {symptom.nombre}
                </li>
              ))}

              {hypothesis.sintomas_orientativos.length === 0 && (
                <li className="text-xs text-[#665E58]">Sin registros.</li>
              )}
            </ul>
          </div>

          <div>
            <p className="text-xs font-bold text-[#3D302C]">
              Síntomas inespecíficos
            </p>

            <ul className="mt-3 space-y-2">
              {hypothesis.sintomas_inespecificos.map((symptom) => (
                <li key={symptom.id} className="text-xs text-[#665E58]">
                  • {symptom.nombre}
                </li>
              ))}

              {hypothesis.sintomas_inespecificos.length === 0 && (
                <li className="text-xs text-[#665E58]">Sin registros.</li>
              )}
            </ul>
          </div>
        </div>

        <div className="mt-6 border-t border-[#E8E1DB] pt-5">
          <p className="text-xs font-bold text-[#3D302C]">
            Síntomas ausentes
          </p>

          <div className="mt-3 flex flex-wrap gap-2">
            {hypothesis.sintomas_ausentes.map((symptom) => (
              <span
                key={symptom}
                className="rounded-lg bg-[#F1E7E2] px-3 py-2 text-[10px] text-[#8F514A]"
              >
                {symptom}
              </span>
            ))}

            {hypothesis.sintomas_ausentes.length === 0 && (
              <span className="text-xs text-[#665E58]">
                No hay síntomas ausentes asociados.
              </span>
            )}
          </div>
        </div>

        <div className="mt-6 border-t border-[#E8E1DB] pt-5">
          <p className="text-xs font-bold text-[#3D302C]">
            Pruebas coincidentes
          </p>

          <div className="mt-3 flex flex-wrap gap-2">
            {hypothesis.pruebas_coincidentes.map((test) => (
              <span
                key={test}
                className="rounded-lg bg-[#F1E7E2] px-3 py-2 text-[10px] text-[#8F514A]"
              >
                {test}
              </span>
            ))}

            {hypothesis.pruebas_coincidentes.length === 0 && (
              <span className="text-xs text-[#665E58]">
                Sin pruebas coincidentes.
              </span>
            )}
          </div>
        </div>

        <div className="mt-6 border-t border-[#E8E1DB] pt-5">
          <p className="text-xs font-bold text-[#3D302C]">
            Reglas activadas
          </p>

          {hypothesis.reglas_activadas.length > 0 ? (
            <div className="mt-3 space-y-3">
              {hypothesis.reglas_activadas.map((rule) => (
                <div
                  key={rule.id}
                  className="rounded-xl bg-[#FFFFFF] p-4"
                >
                  <p className="text-xs font-bold">{rule.id}</p>

                  <p className="mt-2 text-xs leading-5 text-[#665E58]">
                    {rule.justificacion}
                  </p>

                  <p className="mt-2 text-[10px] text-[#665E58]">
                    Fuente: {rule.fuente}
                  </p>
                </div>
              ))}
            </div>
          ) : (
            <p className="mt-2 text-xs text-[#665E58]">
              No se activaron reglas específicas para esta hipótesis.
            </p>
          )}
        </div>

        <div className="mt-6 border-t border-[#E8E1DB] pt-5">
          <p className="text-xs font-bold text-[#3D302C]">
            Fuentes por síntoma
          </p>

          {hypothesis.fuentes_por_sintoma.length > 0 ? (
            <div className="mt-3 space-y-2">
              {hypothesis.fuentes_por_sintoma.map((item) => (
                <div key={item.sintoma} className="text-xs">
                  <span className="font-semibold">{item.sintoma}: </span>
                  <span className="text-[#665E58]">
                    {item.fuentes.map((source) => source.referencia).join(", ") ||
                      "Sin fuente registrada"}
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <p className="mt-2 text-xs text-[#665E58]">
              No hay fuentes adicionales registradas.
            </p>
          )}
        </div>
      </article>
    );
  }

  return (
    <div className="min-h-screen bg-[#F3EFEB] text-[#292421]">
      <aside className="fixed inset-y-0 left-0 z-30 hidden w-[250px] flex-col bg-[#3D302C] text-white lg:flex">
        <div className="flex h-[85px] items-center gap-3 border-b border-white/10 px-7">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-[#A66B61] text-[#3D302C]">
            <PawPrint size={22} />
          </div>

          <div>
            <h1 className="font-heading text-xl font-extrabold tracking-tight">
              VetIA
            </h1>
            <p className="text-[9px] uppercase tracking-[.22em] text-white/50">
              Canine diagnostic system
            </p>
          </div>
        </div>

        <div className="px-5 pt-9">
          <p className="mb-4 px-3 text-[9px] font-bold uppercase tracking-[.2em] text-white/60">
            Plataforma
          </p>

          <button
            onClick={() => setSection("diagnostico")}
            className={`mb-2 flex w-full items-center gap-3 rounded-xl px-4 py-3 text-left text-sm font-semibold transition ${
              section === "diagnostico"
                ? "bg-[#A66B61] text-[#3D302C]"
                : "text-white/70 hover:bg-white/10"
            }`}
          >
            <Stethoscope size={18} />
            Diagnóstico
          </button>

          <button
            onClick={() => setSection("conocimiento")}
            className={`flex w-full items-center gap-3 rounded-xl px-4 py-3 text-left text-sm font-semibold transition ${
              section === "conocimiento"
                ? "bg-[#A66B61] text-[#3D302C]"
                : "text-white/70 hover:bg-white/10"
            }`}
          >
            <Database size={18} />
            Base de conocimiento
          </button>
        </div>

        <div className="mt-auto border-t border-white/10 p-6">
          <div className="flex items-center gap-3">
            <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-white/10">
              <ShieldCheck size={18} />
            </div>

            <div>
              <p className="text-xs font-bold">Sistema VetIA</p>
              <p className="mt-1 text-[10px] text-white/40">
                Motor de inferencia Prolog
              </p>
            </div>
          </div>
        </div>
      </aside>

      <div className="lg:pl-[250px]">
        <header className="sticky top-0 z-20 flex h-[76px] items-center justify-between border-b border-[#E8E1DB] bg-[#F3EFEB]/95 px-5 backdrop-blur sm:px-9">
          <div>
            <p className="text-[9px] font-bold uppercase tracking-[.2em] text-[#665E58]">
              VETIA / SISTEMA CLÍNICO
            </p>

            <h2 className="mt-1 font-heading text-sm font-bold">
              {section === "diagnostico"
                ? "Evaluación diagnóstica"
                : "Base de conocimiento"}
            </h2>
          </div>

          <div className="flex items-center gap-2 rounded-full border border-[#E8E1DB] bg-[#FFFFFF] px-3 py-2">
            <span
              className={`h-2 w-2 rounded-full ${
                backendStatus === "Prolog conectado"
                  ? "bg-green-500"
                  : "bg-amber-500"
              }`}
            />

            <span className="text-[10px] font-bold text-[#665E58]">
              {backendStatus}
            </span>

            <button
              onClick={loadData}
              title="Actualizar conexión y catálogos"
              className="ml-1 text-[#665E58] hover:text-[#3D302C]"
            >
              <RefreshCw size={13} />
            </button>
          </div>
        </header>

        <main className="mx-auto max-w-[1500px] p-5 sm:p-9">
          {loading ? (
            <div className="flex min-h-[400px] flex-col items-center justify-center gap-4">
              <LoaderCircle
                className="animate-spin text-[#3D302C]"
                size={35}
              />
              <p className="text-sm text-[#665E58]">
                Conectando con el sistema VetIA...
              </p>
            </div>
          ) : error && symptoms.length === 0 ? (
            <div className="rounded-2xl border border-[#E8D3CD] bg-[#FFFFFF] p-8">
              <AlertCircle className="mb-4 text-[#A66B61]" size={30} />

              <h2 className="font-heading text-lg font-bold">
                No se pudo cargar VetIA
              </h2>

              <p className="mt-2 text-sm text-[#665E58]">{error}</p>

              <button
                onClick={loadData}
                className="mt-5 rounded-xl bg-[#3D302C] px-5 py-3 text-xs font-bold text-white"
              >
                Reintentar conexión
              </button>
            </div>
          ) : section === "diagnostico" ? (
            <>
              <div className="mb-9">
                <div className="flex items-center gap-2 text-xs font-semibold text-[#665E58]">
                  <HeartPulse size={16} />
                  HERRAMIENTA DE APOYO CLÍNICO CANINO
                </div>

                <h1 className="mt-4 font-heading text-3xl font-extrabold tracking-tight sm:text-4xl">
                  Evaluación de{" "}
                  <span className="text-[#A66B61]">síntomas.</span>
                </h1>

                <p className="mt-3 max-w-2xl text-sm leading-6 text-[#665E58]">
                  Registra los signos clínicos observados en el paciente.
                  VetIA evaluará las coincidencias con las enfermedades
                  registradas en su base de conocimiento.
                </p>
              </div>

              <div className="grid grid-cols-1 items-start gap-7 xl:grid-cols-[minmax(0,1fr)_340px]">
                <section className="min-w-0">
                  <div className="mb-5 flex flex-wrap items-center justify-between gap-3">
                    <div>
                      <p className="text-[9px] font-bold uppercase tracking-[.2em] text-[#665E58]">
                        EVALUACIÓN CLÍNICA
                      </p>

                      <h2 className="mt-1 font-heading text-lg font-bold">
                        Selección de síntomas
                      </h2>
                    </div>

                    <span className="rounded-full bg-[#FFFFFF] px-3 py-2 text-[10px] font-bold text-[#665E58]">
                      {presentSymptoms.length} presentes ·{" "}
                      {absentSymptoms.length} ausentes
                    </span>
                  </div>

                  <div className="space-y-4">
                    {systems.map((system) => {
                      const systemSymptoms = symptoms.filter(
                        (symptom) => symptom.sistema === system
                      );

                      return (
                        <div
                          key={system}
                          className="overflow-hidden rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF]"
                        >
                          <div className="border-b border-[#E8E1DB] px-5 py-4">
                            <h3 className="text-xs font-bold uppercase tracking-wider text-[#3D302C]">
                              {system.replaceAll("_", " ")}
                            </h3>

                            <p className="mt-1 text-[10px] text-[#665E58]">
                              {systemSymptoms.length} síntomas registrados
                            </p>
                          </div>

                          <div className="divide-y divide-[#E8E1DB]">
                            {systemSymptoms.map((symptom) => {
                              const isPresent = presentSymptoms.includes(
                                symptom.id
                              );

                              const isAbsent = absentSymptoms.includes(
                                symptom.id
                              );

                              return (
                                <div
                                  key={symptom.id}
                                  className="flex flex-col justify-between gap-3 px-5 py-4 sm:flex-row sm:items-center"
                                >
                                  <div>
                                    <p className="text-sm font-semibold">
                                      {symptom.nombre}
                                    </p>

                                    <span className="mt-1 inline-block text-[9px] uppercase tracking-wider text-[#665E58]">
                                      {symptom.categoria}
                                    </span>
                                  </div>

                                  <div className="flex shrink-0 gap-2">
                                    <button
                                      onClick={() =>
                                        toggleSymptom(symptom.id, "present")
                                      }
                                      aria-pressed={isPresent}
                                      className={`rounded-lg px-3 py-2 text-[10px] font-bold transition ${
                                        isPresent
                                          ? "bg-[#3D302C] text-white"
                                          : "bg-[#FFFFFF] text-[#665E58] hover:bg-[#E8E1DB]"
                                      }`}
                                    >
                                      Presente
                                    </button>

                                    <button
                                      onClick={() =>
                                        toggleSymptom(symptom.id, "absent")
                                      }
                                      aria-pressed={isAbsent}
                                      className={`rounded-lg px-3 py-2 text-[10px] font-bold transition ${
                                        isAbsent
                                          ? "bg-[#F1E7E2] text-[#8F514A]"
                                          : "bg-[#FFFFFF] text-[#665E58] hover:bg-[#E8E1DB]"
                                      }`}
                                    >
                                      Ausente
                                    </button>
                                  </div>
                                </div>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })}
                  </div>

                  <div className="mt-6 flex flex-wrap gap-3">
                    <button
                      onClick={handleDiagnosis}
                      disabled={analyzing}
                      className="inline-flex items-center gap-2 rounded-xl bg-[#3D302C] px-6 py-4 text-xs font-bold text-white transition hover:bg-[#3D302C] disabled:opacity-50"
                    >
                      {analyzing ? (
                        <LoaderCircle className="animate-spin" size={16} />
                      ) : (
                        <Activity size={16} />
                      )}

                      {analyzing
                        ? "Analizando..."
                        : "Ejecutar evaluación"}
                    </button>

                    <button
                      onClick={resetDiagnosis}
                      className="inline-flex items-center gap-2 rounded-xl border border-[#E8E1DB] bg-[#FFFFFF] px-5 py-4 text-xs font-bold text-[#665E58] hover:bg-[#FFFFFF]"
                    >
                      <RefreshCw size={15} />
                      Limpiar evaluación
                    </button>
                  </div>

                  {error && (
                    <p className="mt-4 rounded-xl bg-[#F1E7E2] p-4 text-xs text-[#8F514A]">
                      {error}
                    </p>
                  )}
                </section>

                <aside className="order-first space-y-5 xl:order-none">
                  <div className="rounded-2xl bg-[#3D302C] p-6 text-white">
                    <div className="flex items-center gap-2 text-[#A66B61]">
                      <Activity size={17} />
                      <span className="text-[9px] font-bold uppercase tracking-[.2em]">
                        Estado de evaluación
                      </span>
                    </div>

                    <h3 className="mt-6 font-heading text-2xl font-extrabold">
                      {result ? "Evaluación completada" : "En espera"}
                    </h3>

                    <p className="mt-2 text-xs leading-5 text-[#F3EFEB]">
                      {result
                        ? "El motor de inferencia ha procesado los síntomas registrados."
                        : "Selecciona los signos clínicos para iniciar el análisis."}
                    </p>

                    <div className="mt-6 grid grid-cols-2 gap-3">
                      <div className="rounded-xl bg-white/10 p-4">
                        <p className="text-[9px] text-[#E8E1DB]">Presentes</p>
                        <p className="mt-1 text-2xl font-bold text-white">
                          {presentSymptoms.length}
                        </p>
                      </div>

                      <div className="rounded-xl bg-white/10 p-4">
                        <p className="text-[9px] text-[#E8E1DB]">Ausentes</p>
                        <p className="mt-1 text-2xl font-bold text-white">
                          {absentSymptoms.length}
                        </p>
                      </div>
                    </div>
                  </div>

                  <div className="rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-6">
                    <div className="flex items-center gap-2">
                      <Database size={17} className="text-[#3D302C]" />
                      <h3 className="text-sm font-bold">
                        Base de conocimiento
                      </h3>
                    </div>

                    <div className="mt-5 space-y-4">
                      <div className="flex items-center justify-between">
                        <span className="text-xs text-[#665E58]">
                          Enfermedades
                        </span>

                        <span className="font-heading text-lg font-bold">
                          {diseases.length}
                        </span>
                      </div>

                      <div className="h-px bg-[#E8E1DB]" />

                      <div className="flex items-center justify-between">
                        <span className="text-xs text-[#665E58]">
                          Síntomas
                        </span>

                        <span className="font-heading text-lg font-bold">
                          {symptoms.length}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div className="rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-5">
                    <div className="flex items-center gap-2 text-[#3D302C]">
                      <ShieldCheck size={17} />
                      <span className="text-xs font-bold">
                        Apoyo a la decisión clínica
                      </span>
                    </div>

                    <p className="mt-3 text-[10px] leading-5 text-[#665E58]">
                      Los resultados representan hipótesis basadas en
                      coincidencias de signos registrados. No constituyen
                      probabilidades ni sustituyen la valoración veterinaria.
                    </p>
                  </div>
                </aside>
              </div>

              {result && (
                <section className="mt-10">
                  <div className="mb-5">
                    <p className="text-[9px] font-bold uppercase tracking-[.2em] text-[#665E58]">
                      MOTOR DE INFERENCIA PROLOG
                    </p>

                    <h2 className="mt-1 font-heading text-xl font-bold">
                      Resultados de la evaluación
                    </h2>

                    <p className="mt-2 text-xs text-[#665E58]">
                      {result.nota}
                    </p>
                  </div>

                  <div className="mb-5 grid grid-cols-1 gap-4 sm:grid-cols-3">
                    <div className="rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-5">
                      <p className="text-xs text-[#665E58]">Estado</p>
                      <p className="mt-2 font-bold">{result.estado}</p>
                    </div>

                    <div className="rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-5">
                      <p className="text-xs text-[#665E58]">
                        Hipótesis encontradas
                      </p>
                      <p className="mt-2 font-heading text-2xl font-bold">
                        {result.total_hipotesis}
                      </p>
                    </div>

                    <div className="rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-5">
                      <p className="text-xs text-[#665E58]">
                        Empates en el límite del top 3
                      </p>
                      <p className="mt-2 font-heading text-2xl font-bold">
                        {result.empate_en_limite_top_3}
                      </p>
                    </div>
                  </div>

                  {result.hipotesis.length > 0 ? (
                    result.hipotesis.map((hypothesis, index) => (
                      <HypothesisCard
                        key={hypothesis.enfermedad.id}
                        hypothesis={hypothesis}
                        index={index}
                      />
                    ))
                  ) : (
                    <div className="rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-7">
                      <CheckCircle2
                        className="mb-3 text-[#3D302C]"
                        size={25}
                      />

                      <h3 className="font-heading font-bold">
                        Sin coincidencias registradas
                      </h3>

                      <p className="mt-2 text-xs text-[#665E58]">
                        El motor no encontró hipótesis con los signos
                        proporcionados.
                      </p>
                    </div>
                  )}

                  {result.reglas_activadas_fuera_del_top_3.length > 0 && (
                    <div className="mt-5 rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-6">
                      <p className="text-xs font-bold">
                        Enfermedades con reglas activadas fuera del top 3
                      </p>

                      <div className="mt-3 flex flex-wrap gap-2">
                        {result.reglas_activadas_fuera_del_top_3.map(
                          (disease) => (
                            <span
                              key={disease}
                              className="rounded-lg bg-[#F1E7E2] px-3 py-2 text-[10px] text-[#8F514A]"
                            >
                              {disease}
                            </span>
                          )
                        )}
                      </div>
                    </div>
                  )}
                </section>
              )}
            </>
          ) : (
            <section>
              <div className="mb-8">
                <p className="text-[9px] font-bold uppercase tracking-[.2em] text-[#665E58]">
                  CONOCIMIENTO VETERINARIO
                </p>

                <h1 className="mt-3 font-heading text-3xl font-extrabold">
                  Enfermedades registradas.
                </h1>

                <p className="mt-3 text-sm text-[#665E58]">
                  Información obtenida directamente de la API de VetIA.
                </p>
              </div>

              <div className="mb-5 flex items-center gap-3 rounded-xl border border-[#E8E1DB] bg-[#FFFFFF] px-4 py-3">
                <Search size={17} className="text-[#665E58]" />

                <input
                  value={search}
                  onChange={(event) => setSearch(event.target.value)}
                  placeholder="Buscar enfermedad..."
                  className="w-full bg-transparent text-sm outline-none"
                />
              </div>

              <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
                {filteredDiseases.map((disease) => (
                  <article
                    key={disease.id}
                    role="button"
                    tabIndex={0}
                    aria-label={`Consultar información de ${disease.nombre}`}
                    onClick={() => void openDiseaseDetails(disease)}
                    onKeyDown={(event) => {
                      if (event.key === "Enter" || event.key === " ") {
                        event.preventDefault();
                        void openDiseaseDetails(disease);
                      }
                    }}
                    className="cursor-pointer rounded-2xl border border-[#E8E1DB] bg-[#FFFFFF] p-6 text-left transition hover:border-[#3D302C] hover:shadow-md focus:outline-none focus:ring-2 focus:ring-[#3D302C]"
                  >
                    <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-[#F1E7E2] text-[#8F514A]">
                      <HeartPulse size={19} />
                    </div>

                    <h3 className="mt-5 font-heading text-base font-bold">
                      {disease.nombre}
                    </h3>

                    <p className="mt-2 text-xs text-[#665E58]">
                      Identificador: {disease.id}
                    </p>

                    <div className="mt-5 flex items-center gap-2 text-[10px] font-bold text-[#3D302C]">
                      Registro de conocimiento
                      <ChevronRight size={13} />
                    </div>
                  </article>
                ))}

                {filteredDiseases.length === 0 && (
                  <p className="text-sm text-[#665E58]">
                    No se encontraron enfermedades.
                  </p>
                )}
              </div>
            </section>
          )}
        </main>
      </div>

      {/* Modal: ficha de enfermedad */}
      {selectedDiseaseId && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-[#111827]/60 p-4 backdrop-blur-sm"
          onClick={closeDiseaseDetails}
        >
          <section
            role="dialog"
            aria-modal="true"
            aria-labelledby="disease-detail-title"
            onClick={(event) => event.stopPropagation()}
            className="disease-modal relative flex max-h-[90vh] w-full max-w-3xl flex-col overflow-hidden rounded-3xl bg-white shadow-2xl"
          >
            {/* Botón fijo: no se desplaza con el contenido */}
            <button
              type="button"
              onClick={closeDiseaseDetails}
              aria-label="Cerrar ficha"
              className="absolute right-5 top-5 z-10 rounded-full border border-[#E8E1DB] bg-white p-2 text-[#665E58] transition hover:bg-[#F4F6F4] md:right-7 md:top-7"
            >
              <span className="text-xl leading-none">×</span>
            </button>

            {/* Único contenedor desplazable */}
            <div ref={modalScrollRef} className="modal-scroll p-6 md:p-9">
              {/* Encabezado */}
              <div className="pr-12">
                <p className="text-xs font-bold uppercase tracking-[0.2em] text-[#A66B61]">
                  Registro de conocimiento
                </p>

                <h2
                  id="disease-detail-title"
                  className="mt-2 text-2xl font-bold text-[#292421] md:text-3xl"
                >
                  {selectedDisease?.nombre ?? "Ficha de enfermedad"}
                </h2>

                <p className="mt-2 text-sm text-[#665E58]">
                  Identificador: {selectedDiseaseId}
                </p>
              </div>

              {/* Cargando */}
              {diseaseDetailLoading && (
                <div className="flex items-center justify-center gap-3 py-16 text-sm text-[#665E58]">
                  <LoaderCircle className="animate-spin" size={20} />
                  Consultando base de conocimiento...
                </div>
              )}

              {/* Error */}
              {diseaseDetailError && (
                <div className="mt-8 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-700">
                  <div className="flex items-start gap-3">
                    <AlertCircle size={18} className="mt-0.5 shrink-0" />
                    <div>
                      <p className="font-semibold">
                        No se pudo cargar la información
                      </p>
                      <p className="mt-1">{diseaseDetailError}</p>
                    </div>
                  </div>

                  <button
                    type="button"
                    onClick={() => {
                      const disease = diseases.find(
                        (item) => item.id === selectedDiseaseId
                      );
                      if (disease) void openDiseaseDetails(disease);
                    }}
                    className="mt-4 rounded-lg bg-red-100 px-4 py-2 text-xs font-bold text-red-800 transition hover:bg-red-200"
                  >
                    Reintentar
                  </button>
                </div>
              )}

              {/* Contenido de la ficha */}
              {selectedDisease && !diseaseDetailLoading && (
                <div className="mt-8 space-y-8">
                  {/* Síntomas */}
                  <div>
                    <div className="mb-4 flex items-center gap-2">
                      <Activity size={18} className="text-[#A66B61]" />

                      <h3 className="font-bold text-[#292421]">
                        Síntomas clínicos asociados
                      </h3>

                      <span className="ml-auto rounded-full bg-[#F1E7E2] px-3 py-1 text-xs font-semibold text-[#665E58]">
                        {selectedDisease.sintomas.length}
                      </span>
                    </div>

                    {selectedDisease.sintomas.length > 0 ? (
                      <div className="grid grid-cols-1 gap-3 min-[641px]:grid-cols-2">
                        {selectedDisease.sintomas.map((symptom) => (
                          <div
                            key={symptom.id}
                            className="rounded-xl border border-[#E8E1DB] bg-[#F4F6F4] p-4"
                          >
                            <p className="text-sm font-semibold text-[#292421]">
                              {symptom.nombre}
                            </p>

                            <p className="mt-1 text-xs capitalize text-[#665E58]">
                              {symptom.categoria.replaceAll("_", " ")}
                              {" · "}
                              {symptom.sistema.replaceAll("_", " ")}
                            </p>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="rounded-xl bg-[#F4F6F4] p-4 text-sm text-[#665E58]">
                        No hay síntomas clínicos registrados.
                      </p>
                    )}
                  </div>

                  {/* Pruebas diagnósticas */}
                  <div>
                    <div className="mb-4 flex items-center gap-2">
                      <ShieldCheck size={18} className="text-[#A66B61]" />

                      <h3 className="font-bold text-[#292421]">
                        Pruebas diagnósticas asociadas
                      </h3>

                      <span className="ml-auto rounded-full bg-[#F1E7E2] px-3 py-1 text-xs font-semibold text-[#665E58]">
                        {selectedDisease.pruebas.length}
                      </span>
                    </div>

                    {selectedDisease.pruebas.length > 0 ? (
                      <div className="grid grid-cols-1 gap-3 min-[641px]:grid-cols-2">
                        {selectedDisease.pruebas.map((test) => (
                          <div
                            key={test.id}
                            className="rounded-xl border border-[#E8E1DB] bg-[#F4F6F4] p-4"
                          >
                            <p className="text-sm font-semibold text-[#292421]">
                              {test.nombre}
                            </p>

                            <p className="mt-1 text-xs capitalize text-[#665E58]">
                              {test.sistema.replaceAll("_", " ")}
                            </p>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="rounded-xl bg-[#F4F6F4] p-4 text-sm text-[#665E58]">
                        No hay pruebas diagnósticas específicas registradas en
                        la base de conocimiento.
                      </p>
                    )}
                  </div>

                  {/* Fuentes bibliográficas */}
                  <div>
                    <div className="mb-4 flex items-center gap-2">
                      <Database size={18} className="text-[#A66B61]" />

                      <h3 className="font-bold text-[#292421]">
                        Fuentes bibliográficas
                      </h3>

                      <span className="ml-auto rounded-full bg-[#F1E7E2] px-3 py-1 text-xs font-semibold text-[#665E58]">
                        {selectedDisease.fuentes.length}
                      </span>
                    </div>

                    {selectedDisease.fuentes.length > 0 ? (
                      <ul className="space-y-2">
                        {selectedDisease.fuentes.map((source, index) => (
                          <li
                            key={`${source}-${index}`}
                            className="rounded-xl border border-[#E8E1DB] p-4 text-sm leading-6 text-[#665E58]"
                          >
                            {source}
                          </li>
                        ))}
                      </ul>
                    ) : (
                      <p className="rounded-xl bg-[#F4F6F4] p-4 text-sm text-[#665E58]">
                        No hay fuentes bibliográficas registradas.
                      </p>
                    )}
                  </div>

                  {/* Nota informativa */}
                  <div className="rounded-xl border border-[#E8E1DB] bg-[#F4F6F4] p-4">
                    <p className="text-xs leading-relaxed text-[#665E58]">
                      Esta información corresponde a las asociaciones
                      registradas en la base de conocimiento VetIA. No
                      representa un diagnóstico confirmado ni sustituye la
                      valoración de un médico veterinario.
                    </p>
                  </div>
                </div>
              )}
            </div>
          </section>
        </div>
      )}
    </div>
  );
}
