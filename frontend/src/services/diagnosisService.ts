import type {
  HealthResponse,
  Symptom,
  Disease,
  Test,
  DiagnosisResponse,
  DiagnosticRequest,
  DiseaseDetails
} from "../types/diagnosis";

const API_URL = "http://127.0.0.1:8000";

async function apiRequest<T>(
  endpoint: string,
  options?: RequestInit
): Promise<T> {
  let response: Response;

  try {
    response = await fetch(`${API_URL}${endpoint}`, {
      ...options,
      headers: {
        "Content-Type": "application/json",
        ...options?.headers,
      },
    });
  } catch {
    throw new Error(
      "No se pudo conectar con VetIA. Comprueba que FastAPI esté ejecutándose."
    );
  }

  if (!response.ok) {
    let message = `Error HTTP ${response.status}`;

    try {
      const data = await response.json();
      message = data.detail ?? message;
    } catch {
      // Se conserva el mensaje HTTP.
    }

    throw new Error(message);
  }

  return response.json() as Promise<T>;
}

export function getHealth(): Promise<HealthResponse> {
  return apiRequest<HealthResponse>("/api/health");
}

export function getSymptoms(): Promise<Symptom[]> {
  return apiRequest<Symptom[]>("/api/sintomas");
}

export function getDiseases(): Promise<Disease[]> {
  return apiRequest<Disease[]>("/api/enfermedades");
}

export function getDiseaseDetails(id: string) {
  return apiRequest<DiseaseDetails>(
    `/api/enfermedades/${encodeURIComponent(id)}`
  );
}

export function getTests(): Promise<Test[]> {
  return apiRequest<Test[]>("/api/pruebas");
}

export function diagnose(
  presentes: string[],
  ausentes: string[]
): Promise<DiagnosisResponse> {
  const body: DiagnosticRequest = {
    presentes,
    ausentes,
  };

  return apiRequest<DiagnosisResponse>("/api/diagnostico", {
    method: "POST",
    body: JSON.stringify(body),
  });
}