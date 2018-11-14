class ImportOpenweatherData
  LON_LEFT   = 22.277179471778027
  LON_RIGHT  = 23.595538846778027
  LAT_BOTTOM = -34.14418624060119
  LAT_TOP    = -33.638043945384716

  attr_accessor :lon_left, :lon_right, :lat_bottom, :lat_top

  def initialize(lon_left: LON_LEFT, lon_right: LON_RIGHT, lat_bottom: LAT_BOTTOM, lat_top: LAT_TOP)
    @lon_left   = lon_left
    @lon_right  = lon_right
    @lat_bottom = lat_bottom
    @lat_top    = lat_top
  end

  def import
    results = fetch_data

    results["list"].each do |result|
      weather_station = WeatherStation.find_or_create(result['id'])
      weather_station.name = result['name']
      weather_station.latitude = result['coord']['Lat']
      weather_station.longitude = result['coord']['Long']
      weather_station.identifier = result['id']

      if weather_station.save
        create_reading(weather_station, result)
      end
    end
  end

  def create_reading(weather_station, result)
    reading_at = Time.at(result['dt']).to_datetime

    return if  weather_station.weather_readings.find_by(reading_at: reading_at)

    reading = weather_station.weather_readings.new
    reading.temprature = result['main']['temp']
    reading.pressure = result['main']['pressure']
    reading.ground_level = result['main']['grnd_level']
    reading.humidity =  result['main']['humidity']
    reading.wind_speed = result['wind']['speed']
    reading.wind_direction = result['wind']['deg']
    reading.rain = result['rain']['3h'] unless result['rain'].nil?
    reading.cloud = result['clouds']['today'] unless result['clouds']['today'].nil?
    reading.description = result['weather'].first['description']
    reading.reading_at = reading_at

    reading.save
  end

  private

  def fetch_data
    url = "/data/2.5/box/city?bbox=#{lon_left},#{lat_bottom},#{lon_right},#{lat_top},12"
    response = data_client.get do |req|
      req.url "#{url}&appid=#{Rails.application.credentials[:openweather_api][:key]}"
    end

    if response.success?
      JSON.parse(response.body)
    end
  end

  def data_client
    @data_client ||= Faraday.new(:url => 'http://api.openweathermap.org')
  end
end