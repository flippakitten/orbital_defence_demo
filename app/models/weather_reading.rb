class WeatherReading < ApplicationRecord
  API_THROTTLE_TIME = 0.02
  belongs_to :weather_station
  has_many :fires, through: :weather_station

  validates :identifier, uniqueness: true
  validates :temprature, presence: true

  after_find :convert_temprature

  class << self
    def find_or_create_by_reading(reading_json, weather_station_id)
      identifier = "#{reading_json['name']}:#{reading_json['dt']}"
      weather_reading = WeatherReading.find_by(identifier: identifier)

      return weather_reading if weather_reading.present?

      WeatherReading.create(
        weather_station_id: weather_station_id,
        identifier: identifier,
        temprature: reading_json['main']['temp'],
        pressure: reading_json['main']['pressure'],
        ground_level: reading_json['main']['grnd_level'],
        humidity: reading_json['main']['humidity'],
        wind_speed: ( reading_json['wind']['speed'] * 3.6),
        wind_direction: reading_json['wind']['deg'],
        rain: reading_json.dig('rain', '3h'),
        cloud: reading_json.dig('clouds', 'today'),
        description: reading_json['weather'].first['description'],
        reading_at: Time.at(reading_json['dt']).to_datetime
      )
    end
  end

  private

  def convert_temprature
    self.temprature = self.temprature - 273.15
  end
end
