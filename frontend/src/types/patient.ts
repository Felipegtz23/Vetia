
export type PatientHealthStatus =
  | "Estable"
  | "Seguimiento"
  | "Pendiente de revisión";

export type DashboardStatIcon =
  | "patients"
  | "appointments"
  | "alerts";

export interface CaninePatient {
  id: string;
  name: string;
  breed: string;
  age: string;
  weight: number;
  chip: string;
  healthStatus: PatientHealthStatus;
  image: string;
  lastVisit?: string;
}

export interface DashboardStat {
  id: string;
  label: string;
  value: string | number;
  description: string;
  icon: DashboardStatIcon;
}
