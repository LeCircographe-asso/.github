class TrainingSessionGeneratorJob < ApplicationJob
  queue_as :default
  
  def perform
    TrainingSession.generate_upcoming_sessions
  end
  
  # S'exécute tous les jours à minuit
  def self.schedule
    set(cron: '0 0 * * *').perform_later
  end
end 