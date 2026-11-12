import {
  Search,
  Bell,
  Clock3,
  CalendarDays,
  ArrowUpRight,
  Plus,
  ClipboardList,
} from "lucide-react";
import { useState } from "react";
import type { CaninePatient } from "../../types/patient";

interface QuickPanelProps {
  patients: CaninePatient[];
  onSelectPatient: (patient: CaninePatient) => void;
}

const reminders = [
  {
    id: "REM-01",
    time: "09:30",
    title: "Control de seguimiento",
    patient: "Luna · Border Collie",
    category: "Seguimiento",
  },
  {
    id: "REM-02",
    time: "11:00",
    title: "Revisión de cartilla",
    patient: "Rocky · Bulldog Francés",
    category: "Vacunación",
  },
  {
    id: "REM-03",
    time: "14:30",
    title: "Control preventivo",
    patient: "Max · Golden Retriever",
    category: "Consulta",
  },
];

export default function QuickPanel({
  patients,
  onSelectPatient,
}: QuickPanelProps) {
  const [search, setSearch] = useState("");
  const [note, setNote] = useState("");
  const [savedNote, setSavedNote] = useState("");

  const results = search.trim()
    ? patients.filter((patient) =>
        `${patient.name} ${patient.breed} ${patient.chip}`
          .toLowerCase()
          .includes(search.toLowerCase())
      )
    : [];

  const saveNote = () => {
    if (!note.trim()) return;
    setSavedNote(note.trim());
    setNote("");
  };

  return (
    <aside className="space-y-6">
      <section className="rounded-3xl border border-[#E8ECE8] bg-white p-6">
        <div className="flex items-center justify-between">
          <h2 className="font-bold tracking-tight text-[#111827]">
            Búsqueda rápida
          </h2>
          <Search size={18} className="text-[#89918A]" />
        </div>

        <div className="relative mt-5">
          <Search
            size={16}
            className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#9AA29B]"
          />

          <input
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Nombre o microchip..."
            className="w-full rounded-xl bg-[#F4F6F4] py-3 pl-10 pr-3 text-xs outline-none transition-all focus:ring-2 focus:ring-[#1E3A2F]/15"
          />
        </div>

        {results.length > 0 && (
          <div className="mt-3 space-y-2">
            {results.map((patient) => (
              <button
                key={patient.id}
                onClick={() => {
                  onSelectPatient(patient);
                  setSearch("");
                }}
                className="flex w-full items-center gap-3 rounded-xl p-2 text-left transition-colors hover:bg-[#F4F6F4]"
              >
                <img
                  src={patient.image}
                  alt=""
                  className="h-9 w-9 rounded-lg object-cover"
                />
                <span className="min-w-0 flex-1">
                  <span className="block text-xs font-bold text-[#111827]">
                    {patient.name}
                  </span>
                  <span className="block truncate text-[10px] text-[#89918A]">
                    {patient.breed}
                  </span>
                </span>
                <ArrowUpRight size={14} />
              </button>
            ))}
          </div>
        )}

        {search.trim() && results.length === 0 && (
          <p className="mt-3 text-xs text-[#89918A]">
            No se encontraron coincidencias.
          </p>
        )}
      </section>

      <section className="rounded-3xl bg-[#1E3A2F] p-6 text-white">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Bell size={17} className="text-[#CCFF00]" />
            <h2 className="font-bold tracking-tight">Agenda del día</h2>
          </div>

          <span className="rounded-full bg-white/10 px-2.5 py-1 text-[9px] text-white/70">
            DEMO
          </span>
        </div>

        <p className="mt-2 text-xs text-white/50">
          Recordatorios ilustrativos de atención canina.
        </p>

        <div className="mt-6 space-y-5">
          {reminders.map((reminder, index) => (
            <div key={reminder.id} className="flex gap-3">
              <div className="flex flex-col items-center">
                <span
                  className={`h-2.5 w-2.5 rounded-full ${
                    index === 0 ? "bg-[#CCFF00]" : "bg-white/35"
                  }`}
                />
                {index !== reminders.length - 1 && (
                  <div className="mt-2 h-12 w-px bg-white/15" />
                )}
              </div>

              <div className="min-w-0 flex-1">
                <div className="flex items-center justify-between gap-2">
                  <span className="text-[10px] font-bold text-[#CCFF00]">
                    {reminder.time}
                  </span>
                  <span className="text-[9px] text-white/40">
                    {reminder.category}
                  </span>
                </div>

                <h3 className="mt-1 text-xs font-semibold">
                  {reminder.title}
                </h3>

                <p className="mt-1 text-[10px] text-white/50">
                  {reminder.patient}
                </p>
              </div>
            </div>
          ))}
        </div>

        <button className="mt-7 flex w-full items-center justify-center gap-2 rounded-xl bg-[#CCFF00] py-3 text-xs font-bold text-[#111827] transition-all duration-300 hover:bg-white">
          <CalendarDays size={15} />
          Abrir agenda
          <ArrowUpRight size={14} />
        </button>
      </section>

      <section className="rounded-3xl border border-[#E8ECE8] bg-white p-6">
        <div className="flex items-center gap-2">
          <ClipboardList size={18} className="text-[#1E3A2F]" />
          <h2 className="font-bold tracking-tight text-[#111827]">
            Notas clínicas
          </h2>
        </div>

        <p className="mt-2 text-xs leading-5 text-[#89918A]">
          Espacio de notas local de demostración. No sustituye el historial
          clínico.
        </p>

        <textarea
          value={note}
          onChange={(event) => setNote(event.target.value)}
          placeholder="Escribe un recordatorio..."
          rows={3}
          className="mt-5 w-full resize-none rounded-xl bg-[#F4F6F4] p-3 text-xs leading-5 outline-none transition-all focus:ring-2 focus:ring-[#1E3A2F]/15"
        />

        <button
          onClick={saveNote}
          disabled={!note.trim()}
          className="mt-3 flex w-full items-center justify-center gap-2 rounded-xl bg-[#111827] py-3 text-xs font-bold text-white transition-all duration-300 hover:bg-[#1E3A2F] disabled:cursor-not-allowed disabled:opacity-40"
        >
          <Plus size={15} />
          Guardar nota temporal
        </button>

        {savedNote && (
          <div className="mt-4 rounded-xl border border-[#E8ECE8] bg-[#F8FAF8] p-3">
            <span className="text-[9px] font-bold uppercase tracking-wider text-[#89918A]">
              Nota guardada en esta sesión
            </span>
            <p className="mt-2 whitespace-pre-wrap text-xs text-[#111827]">
              {savedNote}
            </p>
          </div>
        )}
      </section>

      <section className="rounded-3xl border border-[#E8ECE8] bg-white p-5">
        <div className="flex items-center gap-3">
          <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#F4F6F4] text-[#1E3A2F]">
            <span className="text-lg font-bold">VG</span>
          </div>

          <div className="min-w-0 flex-1">
            <h3 className="text-sm font-bold text-[#111827]">
              Veterinario en sesión
            </h3>
            <p className="mt-1 text-[10px] text-[#89918A]">
              Perfil de demostración
            </p>
          </div>

          <Clock3 size={16} className="text-[#89918A]" />
        </div>
      </section>
    </aside>
  );
}