class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.datetime :date
      t.string :place
      t.string :action
      t.text :memo
      t.references :trip, foreign_key: true

      t.timestamps
    end
    add_index :schedules, %i[trip_id created_at]
  end
end
