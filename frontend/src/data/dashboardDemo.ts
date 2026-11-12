import type { CaninePatient, DashboardStat } from "../types/patient";

export const dashboardStats: DashboardStat[] = [
  {
    id: "patients",
    label: "Pacientes caninos",
    value: "128",
    description: "Registros DEMO",
    icon: "patients",
  },
  {
    id: "appointments",
    label: "Citas de hoy",
    value: "08",
    description: "Agenda DEMO",
    icon: "appointments",
  },
  {
    id: "alerts",
    label: "Seguimientos",
    value: "05",
    description: "Alertas DEMO",
    icon: "alerts",
  },
];

export const caninePatients: CaninePatient[] = [
  {
    id: "VET-001",
    name: "Max",
    breed: "Golden Retriever",
    age: "3 años",
    weight: 28.5,
    chip: "900215000001",
    healthStatus: "Estable",
    image:
      "https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=300&q=85",
    lastVisit: "28 oct. 2026",
  },
  {
    id: "VET-002",
    name: "Luna",
    breed: "Border Collie",
    age: "2 años",
    weight: 18.2,
    chip: "900215000002",
    healthStatus: "Seguimiento",
    image:
      "https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=300&q=85",
    lastVisit: "30 oct. 2026",
  },
  {
    id: "VET-003",
    name: "Rocky",
    breed: "Bulldog Francés",
    age: "4 años",
    weight: 12.8,
    chip: "900215000003",
    healthStatus: "Pendiente de revisión",
    image:
      "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=300&q=85",
    lastVisit: "01 nov. 2026",
  },
  {
    id: "VET-004",
    name: "Milo",
    breed: "Beagle",
    age: "1 año",
    weight: 10.4,
    chip: "900215000004",
    healthStatus: "Estable",
    image:
      "https://images.unsplash.com/photo-1505628346881-b72b27e84530?auto=format&fit=crop&w=300&q=85",
    lastVisit: "01 nov. 2026",
  },
];

export const demoReminders = [
  {
    id: "REM-01",
    time: "09:30",
    title: "Control de seguimiento",
    patient: "Luna · Border Collie",
    type: "Seguimiento",
  },
  {
    id: "REM-02",
    time: "11:00",
    title: "Revisión de cartilla",
    patient: "Rocky · Bulldog Francés",
    type: "Vacunación",
  },
  {
    id: "REM-03",
    time: "14:30",
    title: "Control preventivo",
    patient: "Max · Golden Retriever",
    type: "Consulta",
  },
];