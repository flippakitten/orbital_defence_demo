class AddLatitudeAndLongitudeIndexToFires < ActiveRecord::Migration[5.2]
  def change
    add_index :fires, :longitude
    add_index :fires, :latitude
  end
end
