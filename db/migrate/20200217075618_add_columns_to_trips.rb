class AddColumnsToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :trips, :content, :text
    add_column :trips, :picture, :string
  end
end
