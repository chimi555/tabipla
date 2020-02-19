class AddColumnToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :time, :time
    remove_column :schedules, :date, :datetime
  end
end
