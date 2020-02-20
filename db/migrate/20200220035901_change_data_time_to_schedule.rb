class ChangeDataTimeToSchedule < ActiveRecord::Migration[5.2]
  def change
    change_column :schedules, :time, :string
  end
end
