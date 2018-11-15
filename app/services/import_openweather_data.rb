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
    results = fetch_weather_data

    results.each do |result|
      weather_station = WeatherStation.find_or_create("#{result['name']}:ZA")
      weather_station.name = result['name']
      weather_station.latitude = result['coord']['lat']
      weather_station.longitude = result['coord']['lon']

      weather_station.save
      create_reading_by_coordinates(weather_station, result) unless WeatherReading.find_by(identifier: "#{result['name']}:#{result['dt']}")
    end

  end

  def create_reading_by_coordinates(weather_station, result)
    reading = weather_station.weather_readings.new
    reading.identifier = "#{result['name']}:#{result['dt']}"
    reading.temprature = result['main']['temp']
    reading.pressure = result['main']['pressure']
    reading.ground_level = result['main']['grnd_level']
    reading.humidity =  result['main']['humidity']
    reading.wind_speed = result['wind']['speed']
    reading.wind_direction = result['wind']['deg']
    reading.rain = result['rain']['3h'] unless result['rain'].nil?
    reading.cloud = result['clouds']['today'] unless result['clouds']['today'].nil?
    reading.description = result['weather'].first['description']
    reading.reading_at = Time.at(result['dt']).to_datetime

    puts reading.save!
  end

  private

  def fetch_weather_data
    STATION_COORDS.map { |coord| fetch_data("/data/2.5/weather?lat=#{coord[:lat]}&lon=#{coord[:lon]}") }
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