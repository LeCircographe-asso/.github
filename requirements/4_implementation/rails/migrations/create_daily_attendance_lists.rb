class CreateDailyAttendanceLists < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_attendance_lists do |t|
      t.date :date, null: false
      t.string :list_type, null: false
      t.string :title, null: false
      t.text :description
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.boolean :automatic, default: false
      t.boolean :count_as_session, default: false  # Pour savoir si on décompte les séances

      t.timestamps

      t.index [:date, :list_type], unique: true
      t.index :date
      t.index :list_type
    end
  end
end 