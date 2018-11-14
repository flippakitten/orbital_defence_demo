class CreateWeatherReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :weather_readings do |t|
      t.belongs_to :weather_station, index: true
      t.float :temprature
      t.float :pressure
      t.float :ground_level
      t.integer :humidity
      t.float :wind_speed
      t.float :wind_direction
      t.float :rain
      t.integer :cloud
      t.string :description
      t.datetime :reading_at, index: true, uniqueness: true

      t.timestamps
    end
  end
end
