# WenigZeit

A small UI application to manage my free slots for the calendar to run routine through the week.
Idea to use XP technic and mix the main working hours with routines like: sport, reading, health, accounting, parctices.

## Idea

There is a timeline of the calendar events. Everyday is not the same as yesterday.
Build a strategy to plan routine tasks (the regular duties) through the day.

It happens that you started a day a bit late, and your morning routines canceled.
Make sure their are finished, specify the time range when it could be done and mark that you are ready 
to start the day.


```
Start a day           Work          Lunch                    18:00
│                   │                                       │                             │
│                   │ 30 min Work     30 min Work           │             Dinner          │                  End of the day
│                   │                                       │                             │
│    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │
───┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────►   Time
│    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │
│                   │       15 min Routine      10 min Sport│                             │
│                   │                                       │                             │
│                   │     Daily routines                    │   Evening routines          │     Night routines
│ Morning routines  │  Mix the working hours                │                             │
with routines:                                                         Plan next day
Sport,               specify the interval like Pomodoro       Read book,
Breakfast            and have a list of routines for the      check children's homework
range. See the plan and change the       Walk outside to reach Steps
order. After accomplish confirm or       Plan your vacation
postpone the routine                     Workouts
Walk during that time to have Steps


Routines: Every day
Weekly
Specific day
Monthly
```


## Similar

- Calendar
- Habitica: Gamified Taskmanager (the most beautiful app that I found). It is like TODO list with perks.  
- Habitat
- Routinery: Ritual/Routine
- Habit List

The main difference the routines is not separated as a huge time slot, but integrated to the flow and would give some time to rest from work.
It checks the current calendar events and tries to schedule the activity to the best time.
It would also notify if there is too much scheduled for today.
Idea of my planner to find a slot and it could be work with any of apps to pick a correct routine.

## Implementation

1. Show current events similar to calendar list view
1. Create routine
  1. Title, Duration, Range of possible hours, Frequency
1. Settings page
  1. About page
