class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.string :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :capacity, null: false, default: 15
      t.text :description
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :schedule_exceptions do |t|
      t.references :schedule, null: false, foreign_key: true
      t.date :date, null: false
      t.text :description, null: false
      t.boolean :is_closed, null: false, default: true

      t.timestamps
    end

    add_index :schedules, [:day_of_week, :start_time]
    add_index :schedule_exceptions, :date
  end
end 