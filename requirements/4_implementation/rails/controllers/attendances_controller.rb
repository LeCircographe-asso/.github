class AttendancesController < ApplicationController
  def create
    @training_session = TrainingSession.find_by!(
      schedule_id: params[:schedule_id],
      date: Date.current
    )
    
    @attendance = @training_session.attendances.build(
      user: current_user,
      recorded_by: current_user
    )
    
    if @attendance.save
      redirect_to root_path, notice: 'Présence enregistrée'
    else
      redirect_to root_path, alert: 'Erreur lors de l'enregistrement'
    end
  end
end 