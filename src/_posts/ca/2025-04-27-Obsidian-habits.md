---
layout: post
title: Obsidian + Habits
---

Vegem una manera senzilla de fer seguiment dels nostres hàbits diaris, de manera que tant registrar la informació com visualitzar-la siga fàcil i pràctica.

Per a això utilitzarem dos tipus de notes en Obsidian:

- Notes diàries, on anotarem els hàbits que hàgem complit cada dia.
- Nota de seguiment, que ens permetrà consultar d’un colp d’ull el progrés d’un període concret, com ara una setmana o un mes.

Nota diària

Comencem creant una nota diària. Aquesta nota ha d’incloure tots els hàbits amb els quals estem compromesos, de manera que sempre apareguen en obrir-la. Així ens serà més fàcil recordar-los i fer-ne el seguiment.

Per a automatitzar aquest procés, instal·larem dos plugins de la comunitat:

- Calendar — Ens permetrà visualitzar un calendari dins d’Obsidian i moure’ns fàcilment entre les notes diàries.
- Periodic Notes — Ens permetrà associar plantilles específiques cada vegada que creem una nota diària, setmanal o mensual. A més, podrem definir la carpeta on es guardaran aquestes notes.

Una vegada instal·lats ambdós plugins, crearem una plantilla per a les nostres notes diàries i la guardarem en la carpeta Templates del nostre vault. En aquesta plantilla, podem afegir una secció dedicada als hàbits, per exemple:

```
# Habits
- [ ] Estirar
```

D’aquesta manera, cada dia tindràs una llista clara dels teus hàbits per a marcar conforme els vages completant.

Quan tingues la plantilla llesta, obri les opcions del plugin Periodic Notes. En l’apartat Daily Note, selecciona la plantilla que acabes de crear i, si encara no ho has fet, defineix també la carpeta on es guardaran les teues notes diàries. Això mantindrà el teu vault més organitzat i farà molt més fàcil buscar els teus registres en el futur.

Una vegada configurat tot, només hauràs d’obrir el calendari i, en fer clic en qualsevol dia, es generarà automàticament una nota amb els teus hàbits a punt per a marcar.

I ja està! Si has arribat fins ací, estàs preparat per a fer el següent pas: visualitzar de manera màgica quants dies has complit amb la teua rutina.
Nota de seguiment

En aquesta nota podrem veure d’un colp d’ull tots els hàbits completats durant un període de temps determinat.

Per a això necessitarem instal·lar Dataview, que ens permet fer consultes amb una sintaxi similar a JavaScript i transformar les nostres notes en autèntics panells de dades.

Una vegada instal·lat i activat, només hauràs d’enganxar aquest “tros” de codi en una nota i configurar les variables segons les teues necessitats, perquè et mostre el seguiment dels teus hàbits de forma clara i automàtica.

````
``` dataviewjs
// Config
const FIRST_DAY = "2025-04-01";
const LAST_DAY = "2025-04-30";
const HABITS = ["🤸‍♀️ Estirar", "🦷Fill dental"];
const COMPLETED_ICON = "✅";
const NOT_COMPLETED_ICON = "❌";
const DAILY_NOTES_FOLDER = "BulletJournal/Dia";

// Utilities
function completedHabit(note, habit) {
  if (!note) return null;
  const task = note.file.tasks.find(t => t.text.includes(habit));
  return task?.completed || false;
}

function formatDayDisplay(date) {
  return String(date.day).padStart(2, "0");
}

function checkHabitCompletion(note, habit) {
  return completedHabit(note, habit) ? COMPLETED_ICON : NOT_COMPLETED_ICON;
}

function generateHabitSummary(habits, dailyNotesMap, dateRange) {
  const summary = {};
  habits.forEach(habit => summary[habit] = 0);

  dateRange.forEach(day => {
    const note = dailyNotesMap[day.toISODate()];
    habits.forEach(habit => {
      if (completedHabit(note, habit)) {
        summary[habit]++;
      }
    });
  });

  return summary;
}

function generateDateRange(startDate, endDate) {
  const dates = [];
  for (let day = startDate; day <= endDate; day = dv.date(day).plus({ days: 1 })) {
    dates.push(day);
  }
  return dates;
}

// Main
const startDate = dv.date(FIRST_DAY);
const endDate = dv.date(LAST_DAY);
const monthlyDays = generateDateRange(startDate, endDate);

const dailyNotes = dv.pages(`"${DAILY_NOTES_FOLDER}"`)
  .where(p => p.file.day >= startDate && p.file.day <= endDate);

const dailyNotesMap = {};
dailyNotes.forEach(note => {
  dailyNotesMap[note.file.day.toISODate()] = note;
});

// Table
dv.table(
  ["Día", ...HABITS],
  monthlyDays.map(day => [
    formatDayDisplay(day),
    ...HABITS.map(habit =>
      checkHabitCompletion(dailyNotesMap[day.toISODate()], habit))
  ])
);

dv.el("hr", "");

// Summary
const habitSummary = generateHabitSummary(HABITS, dailyNotesMap, monthlyDays);
const summaryLines = Object.entries(habitSummary)
  .map(([habit, count]) => `${habit}: ${count}/${monthlyDays.length} días`);

dv.list(summaryLines);
````
