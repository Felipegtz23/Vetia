export interface Symptom {
  id: string;
  nombre: string;
  categoria: string;
  sistema: string;
}

export interface Disease {
  id: string;
  nombre: string;
}

export interface Test {
  id: string;
  nombre: string;
}

export interface HealthResponse {
  status: string;
  prolog: string;
  enfermedades_registradas: number;
}

export interface SymptomObservations {
  presentes: string[];
  ausentes: string[];
  desconocidos: string[];
  contradictorios: string[];
}

export interface RuleDetail {
  id: string;
  enfermedad: string;
  premisas: string[];
  conclusion: string;
  justificacion: string;
  fuente_id: string;
  fuente: string;
}

export interface SymptomSource {
  sintoma: string;
  fuentes: {
    id: string;
    referencia: string;
  }[];
}

export interface Hypothesis {
  enfermedad: Disease;
  coincidencias: number;
  total_sintomas_registrados: number;
  porcentaje_coincidencia: number;
  interpretacion_porcentaje: string;
  sintomas_coincidentes: Symptom[];
  sintomas_orientativos: Symptom[];
  sintomas_inespecificos: Symptom[];
  pruebas_coincidentes: string[];
  sintomas_no_reportados: string[];
  sintomas_ausentes: string[];
  reglas_activadas: RuleDetail[];
  fuentes_por_sintoma: SymptomSource[];
}

export interface DiagnosisResponse {
  estado: string;
  observaciones: SymptomObservations;
  total_hipotesis: number;
  hipotesis: Hypothesis[];
  empate_en_limite_top_3: number;
  reglas_activadas_fuera_del_top_3: string[];
  nota: string;
}

export interface DiagnosticRequest {
  presentes: string[];
  ausentes: string[];
}

export interface DiseaseDetails {
  id: string;
  nombre: string;
  sintomas: Symptom[];
  pruebas: Symptom[];
  fuentes: string[];
}