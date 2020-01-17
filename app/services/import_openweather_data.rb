class ImportOpenweatherData
  attr_reader :fire

  def initialize(fire)
    @fire = fire
  end

  def fetch_reading_and_create_station_data
    reading_json = open_weather_data

    return unless reading_json

    weather_station = WeatherStation.find_or_create(reading_json)
    weather_reading = WeatherReading.find_or_create_by_reading(reading_json, weather_station.id)

    return weather_station, weather_reading
  end

  private

  def open_weather_data
    response = data_client.get do |req|
      req.url "/data/2.5/weather?lat=#{fire.latitude}&lon=#{fire.longitude}&appid=#{open_weather_key}"
    end

    sleep WeatherReading::API_THROTTLE_TIME

    JSON.parse(response.body) if response.success?
  end

  def data_client
    @data_client ||= Faraday.new(url: 'http://api.openweathermap.org')
  end

  def open_weather_key
    @open_weather_key ||= Rails.application.credentials[:openweather_api][:key]
  end
end