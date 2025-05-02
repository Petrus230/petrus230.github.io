---
layout: post
title: Obsidian + Habits
---

Vamos a ver una forma sencilla de hacer seguimiento de nuestros hábitos diarios, de manera que tanto registrar la información como visualizarla resulte fácil y práctico.

Para ello utilizaremos dos tipos de notas en Obsidian:

1. **Notas diarias**, donde anotaremos los hábitos que hayamos completado cada día.
2. **Nota de seguimiento**, que nos permitirá consultar de un vistazo el progreso de un periodo concreto, como una semana o un mes.

---

## Nota diaria

Empecemos por crear una nota diaria. Esta nota debe incluir todos los hábitos con los que estamos comprometidos, de modo que siempre aparezcan al abrirla. Así nos resultará más fácil recordarlos y hacer seguimiento.

Para automatizar este proceso, instalaremos dos _community plugins_:

1. **Calendar** — Nos permitirá visualizar un calendario dentro de Obsidian y movernos fácilmente entre las notas diarias.
2. **Periodic Notes** — Nos permitirá asociar plantillas específicas cada vez que creemos una nota diaria, semanal o mensual. Además, podremos definir la carpeta donde se guardarán estas notas.

---

Una vez instalados ambos plugins, crearemos una plantilla para nuestras notas diarias y la guardaremos en la carpeta `Templates` de nuestro _vault_. En esa plantilla, podemos añadir una sección dedicada a los hábitos, por ejemplo:

```
# Habits
- [ ] Estirar
```

De esta forma, cada día tendrás una lista clara de tus hábitos para marcar a medida que los completes.

Cuando ya tengas tu plantilla lista, abre las opciones del plugin _Periodic Notes_. En el apartado **Daily Note** selecciona la plantilla que acabas de crear y, si aún no lo has hecho, define también la carpeta donde se guardarán tus notas diarias. Esto mantendrá tu _vault_ más organizado y hará mucho más fácil buscar tus registros en el futuro.

---

Una vez configurado todo, solo tendrás que abrir el calendario y, al hacer clic en cualquier día, se generará automáticamente una nota con tus hábitos listos para marcar.

¡Y listo! Si ya has llegado hasta aquí, estás preparado para dar el siguiente paso: visualizar de forma mágica cuántos días has cumplido con tu rutina.

## Nota de seguimiento

En esta nota vamos a poder ver de un vistazo todos los hábitos completados durante un periodo de tiempo determinado.

Para ello necesitaremos instalar **Dataview**, que nos permite hacer consultas con sintaxis similar a JavaScript y transformar nuestras notas en auténticos paneles de datos.

Una vez instalado y activado, solo tendrás que pegar este “mondongo” de código en una nota y configurar las variables según tus necesidades, para que te muestre el seguimiento de tus hábitos de forma clara y automática.

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
