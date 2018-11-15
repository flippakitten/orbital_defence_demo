class WeatherStation < ApplicationRecord
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_many :weather_readings

  validates :identifier, uniqueness: true

  class << self
    def find_or_create(identifier)
      station = WeatherStation.find_by(identifier: identifier)

      return station if station.present?

      WeatherStation.new(identifier: identifier)
    end
  end
end
