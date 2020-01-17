class AddWeatherStationToFire < ActiveRecord::Migration[5.2]
  def change
    add_reference :fires, :weather_station, index: true
  end
end
