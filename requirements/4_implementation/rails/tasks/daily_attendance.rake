namespace :attendance do
  desc "Crée la liste d'entraînement quotidienne"
  task create_daily_list: :environment do
    DailyAttendanceList.generate_daily_training
  end
end 