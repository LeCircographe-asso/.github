namespace :training_sessions do
  desc "Génère les sessions d'entraînement pour la semaine à venir"
  task generate: :environment do
    TrainingSession.generate_upcoming_sessions
  end
end 