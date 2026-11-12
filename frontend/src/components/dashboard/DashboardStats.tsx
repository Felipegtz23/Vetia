
import {
  PawPrint,
  CalendarCheck,
  AlertTriangle,
  ArrowUpRight,
} from "lucide-react";

import type { DashboardStat, DashboardStatIcon } from "../../types/patient";

interface DashboardStatsProps {
  stats: DashboardStat[];
}

const icons: Record<DashboardStatIcon, typeof PawPrint> = {
  patients: PawPrint,
  appointments: CalendarCheck,
  alerts: AlertTriangle,
};

export default function DashboardStats({ stats }: DashboardStatsProps) {
  return (
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
      {stats.map((stat) => {
        const Icon = icons[stat.icon];

        return (
          <article
            key={stat.id}
            className="group rounded-3xl border border-[#E8ECE8] bg-white p-6 transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_15px_40px_rgba(30,58,47,.07)]"
          >
            <div className="flex items-center justify-between">
              <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[#F4F6F4] text-[#1E3A2F] transition-colors duration-300 group-hover:bg-[#CCFF00]">
                <Icon size={21} strokeWidth={1.8} />
              </div>

              <ArrowUpRight
                size={17}
                className="text-[#A5ACA6] transition-transform duration-300 group-hover:-translate-y-1 group-hover:translate-x-1"
              />
            </div>

            <p className="mt-7 text-sm font-medium text-[#6E7273]">
              {stat.label}
            </p>

            <div className="mt-1 flex items-end justify-between">
              <span className="text-4xl font-bold tracking-tight text-[#111827]">
                {stat.value}
              </span>

              <span className="mb-1 text-[9px] font-bold uppercase tracking-wider text-[#89918A]">
                {stat.description}
              </span>
            </div>
          </article>
        );
      })}
    </div>
  );
}
