class ChangeDatatypeTimeOfSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :time, :string
  end
end
