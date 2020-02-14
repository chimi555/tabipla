class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :trips, [:user_id, :created_at]
  end
end
