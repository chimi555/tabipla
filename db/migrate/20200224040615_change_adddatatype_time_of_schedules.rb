class ChangeAdddatatypeTimeOfSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :time, :time
  end
end
