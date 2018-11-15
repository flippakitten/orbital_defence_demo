class AddWeatherReadingToFires < ActiveRecord::Migration[5.2]
  def change
    add_column :fires, :weather_reading_id, :integer
  end
end
