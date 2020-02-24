class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.date :date
      t.references :trip, foreign_key: true

      t.timestamps
    end
    add_index :days, %i[trip_id created_at]
  end
end
