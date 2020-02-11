class WeatherStation < ApplicationRecord
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_many :weather_readings, dependent: :destroy
  has_many :fires

  validates :identifier, uniqueness: true

  class << self
    def find_or_create(reading_json)
      identifier = "#{reading_json['name']}:AUS"
      weather_station = WeatherStation.find_by(identifier: identifier)

      return weather_station if weather_station.present?

      WeatherStation.create(
          identifier: identifier,
          name: reading_json['name'],
          latitude: reading_json['coord']['lat'],
          longitude: reading_json['coord']['lon']
      )
    end
  end

  def latest_weather_reading
    self.weather_readings.last
  end
end