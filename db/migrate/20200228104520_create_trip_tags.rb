class CreateTripTags < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_tags do |t|
      t.integer :trip_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :trip_tags, :trip_id
    add_index :trip_tags, :tag_id
    add_index :trip_tags, [:trip_id,:tag_id],unique: true
  end
end
