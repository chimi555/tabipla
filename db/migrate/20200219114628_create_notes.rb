class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :subject
      t.text :content
      t.references :trip, foreign_key: true

      t.timestamps
    end
    add_index :notes, %i[trip_id created_at]
  end
end
