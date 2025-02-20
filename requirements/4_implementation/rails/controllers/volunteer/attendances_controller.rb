class Volunteer::AttendancesController < Volunteer::BaseController
  def index
    @daily_list = DailyAttendanceList.today
    @attendances = @daily_list.attendances.includes(:user, :recorded_by)
  end

  def create
    @daily_list = DailyAttendanceList.today
    @user = User.find_by!(member_number: params[:member_number])

    @attendance = @daily_list.attendances.build(
      user: @user,
      recorded_by: current_user,
      subscription: @user.subscriptions.active.first
    )

    if @attendance.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to volunteer_attendances_path, notice: "Présence enregistrée" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("check_in_error", @attendance.errors.full_messages.to_sentence) }
        format.html { redirect_to volunteer_attendances_path, alert: @attendance.errors.full_messages.to_sentence }
      end
    end
  end
end 