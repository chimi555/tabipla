# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :trips, %i[user_id created_at]
  end
end
