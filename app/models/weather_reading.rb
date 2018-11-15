class WeatherReading < ApplicationRecord
  belongs_to :weather_station

  validates :identifier, uniqueness: true
end
