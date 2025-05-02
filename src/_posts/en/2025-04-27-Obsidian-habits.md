---
layout: post
title: Obsidian + Habits
---

Let’s look at a simple way to track our daily habits, so that both logging the information and visualizing it are easy and practical.

To do this, we’ll use two types of notes in Obsidian:

- Daily notes, where we’ll record the habits we’ve completed each day.
- Tracking note, which will allow us to view at a glance the progress over a specific period, like a week or a month.

Daily Note

Let’s start by creating a daily note. This note should include all the habits we’re committed to, so they always appear when we open it. This makes it easier to remember them and track them.

To automate this process, we’ll install two community plugins:

- Calendar — This lets us view a calendar inside Obsidian and easily navigate between daily notes.
- Periodic Notes — This allows us to associate specific templates each time we create a daily, weekly, or monthly note. We can also define the folder where these notes will be saved.

Once both plugins are installed, we’ll create a template for our daily notes and save it in the Templates folder of our vault. In that template, we can add a section dedicated to habits, for example:

```
# Habits
- [ ] Estirar
```

This way, every day you'll have a clear list of your habits to check off as you complete them.

Once your template is ready, open the Periodic Notes plugin settings. Under the Daily Note section, select the template you just created and, if you haven’t already, define the folder where your daily notes will be stored. This will keep your vault more organized and make it much easier to search your records in the future.

Once everything is set up, all you have to do is open the calendar and, by clicking on any day, a note will automatically be generated with your habits ready to be checked off.

And that’s it! If you’ve made it this far, you’re ready for the next step: magically visualizing how many days you’ve stuck to your routine.
Tracking Note

In this note, we’ll be able to see at a glance all the habits completed over a certain time period.

To do this, we’ll need to install Dataview, which allows us to make queries with syntax similar to JavaScript and transform our notes into real data dashboards.

Once installed and activated, you’ll just need to paste this chunk of code into a note and configure the variables to your needs, so it shows your habit tracking clearly and automatically.

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
