import { useState } from "react";
import {
  PawPrint,
  Stethoscope,
  CalendarDays,
  Syringe,
  Settings,
  PanelLeftClose,
} from "lucide-react";

const navigation = [
  { label: "Pacientes caninos", icon: PawPrint },
  { label: "Consultas y diagnósticos", icon: Stethoscope },
  { label: "Agenda y citas", icon: CalendarDays },
  { label: "Vacunación", icon: Syringe },
];

interface DashboardSidebarProps {
  activeSection: string;
  onNavigate: (section: string) => void;
}

export default function DashboardSidebar({
  activeSection,
  onNavigate,
}: DashboardSidebarProps) {
  const [collapsed, setCollapsed] = useState(false);

  return (
    <aside
      className={`fixed inset-y-0 left-0 z-40 flex flex-col bg-[#1E3A2F] text-white transition-all duration-300 ${
        collapsed ? "w-[88px]" : "w-[260px]"
      }`}
    >
      <div className="flex h-24 items-center justify-between px-6">
        <a href="#dashboard" className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-[#CCFF00] text-[#111827]">
            <PawPrint size={23} strokeWidth={2.3} />
          </div>

          {!collapsed && (
            <span className="text-2xl font-black tracking-tighter">
              VET<span className="text-[#CCFF00]">IA</span>
            </span>
          )}
        </a>

        <button
          onClick={() => setCollapsed(!collapsed)}
          aria-label="Contraer navegación"
          className="text-white/50 transition-colors hover:text-[#CCFF00]"
        >
          <PanelLeftClose size={18} />
        </button>
      </div>

      {!collapsed && (
        <div className="px-7 pb-4 pt-5">
          <span className="text-[9px] font-bold uppercase tracking-[.22em] text-white/35">
            Workspace
          </span>
        </div>
      )}

      <nav className="flex-1 space-y-2 px-4">
        {navigation.map((item) => {
          const Icon = item.icon;
          const active = activeSection === item.label;

          return (
            <button
              key={item.label}
              onClick={() => onNavigate(item.label)}
              title={collapsed ? item.label : undefined}
              className={`flex w-full items-center gap-4 rounded-xl px-3 py-3.5 text-left text-sm transition-all duration-300 ${
                active
                  ? "bg-[#CCFF00] font-bold text-[#111827]"
                  : "text-white/65 hover:bg-white/10 hover:text-white"
              }`}
            >
              <Icon size={19} strokeWidth={1.8} />
              {!collapsed && <span>{item.label}</span>}
            </button>
          );
        })}
      </nav>

      <div className="border-t border-white/10 p-4">
        <button
          onClick={() => onNavigate("Configuración")}
          title={collapsed ? "Configuración" : undefined}
          className={`flex w-full items-center gap-4 rounded-xl px-3 py-3.5 text-sm transition-colors hover:bg-white/10 ${
            activeSection === "Configuración"
              ? "text-[#CCFF00]"
              : "text-white/60"
          }`}
        >
          <Settings size={19} strokeWidth={1.8} />
          {!collapsed && <span>Configuración</span>}
        </button>

        {!collapsed && (
          <p className="mt-6 px-3 text-[9px] tracking-wider text-white/30">
            VETIA · CANINE INTELLIGENCE
          </p>
        )}
      </div>
    </aside>
  );
}