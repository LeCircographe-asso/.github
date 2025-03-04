class SchedulesController < ApplicationController
  skip_before_action :authenticate_user!  # Pas d'authentification requise
  
  def index
    @schedules = Schedule.includes(:exceptions)
                        .order(:day_of_week, :start_time)
    @exceptions = ScheduleException.current_and_upcoming
  end
end 