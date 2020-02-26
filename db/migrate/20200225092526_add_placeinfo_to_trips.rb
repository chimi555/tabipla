class AddPlaceinfoToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :trips, :country_code, :string
    add_column :trips, :area, :string
  end
end
