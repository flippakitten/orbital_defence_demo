class ImportOpenweatherData
  STATION_COORDS = [
    {lat: -33.979097, lon: 22.437487},
    {lat: -34.049194, lon: 22.394336},
    {lat: -33.997136, lon: 22.619241},
    {lat: -34.018012, lon: 22.812970},
    {lat: -34.036530, lon: 23.055158},
    {lat: -34.043781, lon: 23.365104},
    {lat: -33.656132, lon: 23.126808}
  ]

  def import
    Fire.where(detected_at: (Time.now - 24.hours)..Time.now).each do |fire|
      result = fetch_data("/data/2.5/weather?lat=#{fire.latitude}&lon=#{fire.longitude}")

      next unless result

      weather_station = WeatherStation.find_or_create("#{result['name']}:AUS")

      unless weather_station.persisted?
        weather_station.name = result['name']
        weather_station.latitude = result['coord']['lat']
        weather_station.longitude = result['coord']['lon']

        weather_station.save
      end

      unless WeatherReading.find_by(identifier: "#{result['name']}:#{result['dt']}")
        create_reading_by_coordinates(weather_station, result)
      end
      sleep 1
    end
  end

  def create_reading_by_coordinates(weather_station, result)
    reading = weather_station.weather_readings.new
    reading.identifier = "#{result['name']}:#{result['dt']}"
    reading.temprature = result['main']['temp']
    reading.pressure = result['main']['pressure']
    reading.ground_level = result['main']['grnd_level']
    reading.humidity =  result['main']['humidity']
    reading.wind_speed = ( result['wind']['speed'] * 3.6)
    reading.wind_direction = result['wind']['deg']
    reading.rain = result['rain']['3h'] unless result['rain'].nil?
    reading.cloud = result['clouds']['today'] unless result['clouds']['today'].nil?
    reading.description = result['weather'].first['description']
    reading.reading_at = Time.at(result['dt']).to_datetime

    reading.save!
  end

  private

  def fetch_weather_data
    Fire.find_each.map { |fire| fetch_data("/data/2.5/weather?lat=#{fire.latitude}&lon=#{fire.longitude}") }
    #STATION_COORDS.map { |coord| fetch_data("/data/2.5/weather?lat=#{coord[:lat]}&lon=#{coord[:lon]}") }
  end

  def fetch_data(url)
    response = data_client.get do |req|
      req.url "#{url}&appid=#{Rails.application.credentials[:openweather_api][:key]}"
    end

    JSON.parse(response.body) if response.success?
  end

  def data_client
    @data_client ||= Faraday.new(url: 'http://api.openweathermap.org')
  end
end