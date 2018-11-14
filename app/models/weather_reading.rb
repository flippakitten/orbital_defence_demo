class WeatherReading < ApplicationRecord
  belongs_to :weather_station

  validates :reading_at, uniqueness: true
end
