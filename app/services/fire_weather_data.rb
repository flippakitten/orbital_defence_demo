# frozen_string_literal: true

class FireWeatherData
  attr_reader :fire

  def initialize(fire)
    @fire = fire
  end

  def find_or_create_weather
    weather_station = WeatherStation.within(10, origin: [fire.latitude, fire.longitude]).first

    if weather_station.present? && weather_reading_within_limits?(weather_station)
      return weather_station, weather_station.weather_readings.last
    else
      create_station_and_reading
    end
  end

  def create_station_and_reading
    reading_json = OpenWeatherApi::WeatherByCoordinates.fetch(latitude: fire.latitude, longitude: fire.longitude)

    return unless reading_json

    weather_station = WeatherStation.find_or_create(reading_json)
    weather_reading = WeatherReading.find_or_create_by_reading(reading_json, weather_station.id)

    return weather_station, weather_reading
  end

  def weather_reading_within_limits?(weather_station)
    weather_station.weather_readings&.last.reading_at.between?(fire.detected_at - 30.minutes, fire.detected_at + 30.minutes)
  end
end