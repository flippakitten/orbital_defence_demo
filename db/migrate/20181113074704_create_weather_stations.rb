class CreateWeatherStations < ActiveRecord::Migration[5.2]
  def change
    create_table :weather_stations do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :identifier, index: true, uniqueness: true

      t.timestamps
    end
  end
end
