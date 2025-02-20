namespace :attendance do
  desc "Crée la liste de présence du jour (sauf lundi)"
  task create_daily_list: :environment do
    DailyAttendanceList.generate_for_today
  end
end 