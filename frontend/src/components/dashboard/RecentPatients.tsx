
import { ArrowUpRight, ChevronRight, Search, Weight } from "lucide-react";
import { useState } from "react";
import type { CaninePatient } from "../../types/patient";

interface RecentPatientsProps {
  patients: CaninePatient[];
  onSelectPatient: (patient: CaninePatient) => void;
}

function StatusBadge({
  status,
}: {
  status: CaninePatient["healthStatus"];
}) {
  const styles: Record<CaninePatient["healthStatus"], string> = {
    Estable: "bg-[#E8F3E8] text-[#356A42]",
    Seguimiento: "bg-[#FFF4D9] text-[#956B16]",
    "Pendiente de revisión": "bg-[#FCE9E6] text-[#A44736]",
  };

  return (
    <span
      className={`inline-flex rounded-full px-3 py-1.5 text-[10px] font-bold ${styles[status]}`}
    >
      {status}
    </span>
  );
}

export default function RecentPatients({
  patients,
  onSelectPatient,
}: RecentPatientsProps) {
  const [query, setQuery] = useState("");

  const filteredPatients = patients.filter((patient) =>
    [patient.name, patient.breed, patient.chip, patient.id]
      .join(" ")
      .toLowerCase()
      .includes(query.toLowerCase())
  );

  return (
    <section className="rounded-3xl border border-[#E8ECE8] bg-white p-6 sm:p-8">
      <div className="flex flex-col justify-between gap-4 sm:flex-row sm:items-center">
        <div>
          <span className="text-[9px] font-bold uppercase tracking-[.2em] text-[#89918A]">
            PATIENT DIRECTORY
          </span>

          <h2 className="mt-2 text-2xl font-bold tracking-tight text-[#111827]">
            Pacientes recientes
          </h2>

          <p className="mt-1 text-xs text-[#8A928C]">
            Directorio canino · Datos de demostración
          </p>
        </div>

        <button
          onClick={() => setQuery("")}
          className="inline-flex items-center gap-2 self-start rounded-full bg-[#1E3A2F] px-5 py-3 text-xs font-bold text-white transition-all duration-300 hover:bg-[#315B49] sm:self-auto"
        >
          Ver directorio
          <ArrowUpRight size={15} />
        </button>
      </div>

      <div className="relative mt-7">
        <Search
          size={17}
          className="absolute left-4 top-1/2 -translate-y-1/2 text-[#9AA29B]"
        />

        <input
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Buscar por nombre, raza o microchip..."
          className="w-full rounded-xl border border-[#E9EDE9] bg-[#F8FAF8] py-3.5 pl-11 pr-4 text-sm outline-none transition-all focus:border-[#1E3A2F] focus:ring-2 focus:ring-[#1E3A2F]/10"
        />
      </div>

      <div className="mt-6 space-y-3">
        {filteredPatients.length > 0 ? (
          filteredPatients.map((patient) => (
            <button
              key={patient.id}
              onClick={() => onSelectPatient(patient)}
              className="group flex w-full flex-col gap-4 rounded-2xl border border-transparent bg-[#F8FAF8] p-4 text-left transition-all duration-300 hover:border-[#DCE5DC] hover:bg-white hover:shadow-[0_8px_25px_rgba(30,58,47,.05)] sm:flex-row sm:items-center"
            >
              <img
                src={patient.image}
                alt={`Fotografía de ${patient.name}`}
                className="h-14 w-14 rounded-2xl object-cover"
              />

              <div className="min-w-0 flex-1">
                <div className="flex flex-wrap items-center gap-2">
                  <h3 className="font-bold tracking-tight text-[#111827]">
                    {patient.name}
                  </h3>

                  <span className="text-[10px] text-[#A0A7A0]">
                    {patient.id}
                  </span>
                </div>

                <p className="mt-1 text-xs text-[#777F79]">
                  {patient.breed} · {patient.age}
                </p>

                <p className="mt-2 text-[10px] text-[#9AA29B]">
                  Chip: {patient.chip}
                </p>
              </div>

              <div className="flex items-center justify-between gap-4 sm:flex-col sm:items-end">
                <StatusBadge status={patient.healthStatus} />

                <span className="inline-flex items-center gap-1 text-xs text-[#6E7273]">
                  <Weight size={13} />
                  {patient.weight} kg
                </span>
              </div>

              <ChevronRight
                size={17}
                className="hidden text-[#A4ACA5] transition-transform group-hover:translate-x-1 sm:block"
              />
            </button>
          ))
        ) : (
          <div className="rounded-2xl bg-[#F8FAF8] px-5 py-10 text-center">
            <Search size={22} className="mx-auto text-[#A0A7A0]" />
            <p className="mt-3 text-sm font-semibold text-[#111827]">
              No se encontraron pacientes
            </p>
            <p className="mt-1 text-xs text-[#89918A]">
              Prueba con otro nombre, raza o número de microchip.
            </p>
          </div>
        )}
      </div>
    </section>
  );
}
