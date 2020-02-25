class RemoveTripFromSchedules < ActiveRecord::Migration[5.2]
  def change
    remove_reference :schedules, :trip, index: true, foreign_key: true
    add_reference :schedules, :day, index: true, foreign_key: true
  end
end
