class ChangeFireWeatherReadingToBigInt < ActiveRecord::Migration[5.2]
  def up
    change_column :fires, :weather_reading_id, :bigint
  end

  def down
    change_column :fires, :weather_reading_id, :int
  end
end
