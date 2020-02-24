class RemoveTripFromNotes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :notes, :trip, index: true, foreign_key: true
    add_reference :notes, :day, index: true, foreign_key: true
  end
end
