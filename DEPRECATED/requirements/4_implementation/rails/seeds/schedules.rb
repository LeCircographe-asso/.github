# db/seeds/schedules.rb

# Horaires réguliers
Schedule.create!([
  {
    day_of_week: "lundi",
    start_time: "18:00",
    end_time: "22:00",
    capacity: 20,
    description: "Entraînement libre"
  },
  {
    day_of_week: "mercredi",
    start_time: "14:00",
    end_time: "18:00",
    capacity: 15,
    description: "Entraînement jeunes"
  },
  {
    day_of_week: "mercredi",
    start_time: "18:00",
    end_time: "22:00",
    capacity: 20,
    description: "Entraînement libre"
  },
  {
    day_of_week: "samedi",
    start_time: "14:00",
    end_time: "18:00",
    capacity: 20,
    description: "Entraînement tous niveaux"
  }
])

# Exceptions (fermetures)
ScheduleException.create!([
  {
    schedule: Schedule.first,
    date: 1.week.from_now,
    description: "Fermeture exceptionnelle pour maintenance",
    is_closed: true
  },
  {
    schedule: Schedule.last,
    date: 2.weeks.from_now,
    description: "Stage spécial débutants",
    is_closed: false
  }
]) 