class Volunteer::AttendanceListsController < Volunteer::BaseController
  def index
    @attendance_lists = DailyAttendanceList.recent
                                         .includes(:created_by)
                                         .order(date: :desc)
  end

  def new
    @attendance_list = DailyAttendanceList.new(date: params[:date])
  end

  def create
    @attendance_list = DailyAttendanceList.new(attendance_list_params)
    @attendance_list.created_by = current_user

    if @attendance_list.save
      redirect_to volunteer_attendance_lists_path, 
                  notice: "Liste de présence créée avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def attendance_list_params
    params.require(:attendance_list).permit(
      :date, :list_type, :title, :description, :count_as_session
    )
  end
end 