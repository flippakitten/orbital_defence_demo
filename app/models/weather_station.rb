class WeatherStation < ApplicationRecord
  has_many :weather_readings

  validates :identifier, uniqueness: true

  class << self
    def find_or_create(id)
      station = WeatherStation.find_by(identifier: id)

      return station if station.present?

      WeatherStation.new(identifier: id)
    end
  end
end
