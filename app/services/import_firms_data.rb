class ImportFirmsData
  require 'csv'
  FIRMS_DATA_URLS = {
    modis: '/api/v2/content/archives/FIRMS/c6/Southern_Africa/MODIS_C6_Southern_Africa_MCD14DL_NRT_',
    viirs: '/api/v2/content/archives/FIRMS/viirs/Southern_Africa/VIIRS_I_Southern_Africa_VNP14IMGTDL_NRT_'
  }
  class << self
    def import
      FIRMS_DATA_URLS.each do |key, url|
        response = fetch_data(key, url, julian_date)
        if response.success?
          csv_text = response.body
          parse_and_create(csv_text: csv_text, scan_type: key)
        else
          Rails.logger.error("Failed to get data - #{response.status}: #{response.body}")
        end
      end
    end

    def import_file(file:, scan_type:)
      csv_text = File.read(Rails.root.join('external_data', file))
      parse_and_create(csv_text: csv_text, scan_type: scan_type)
    end

    def parse_and_create(csv_text:, scan_type:)
      csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

      csv.each do |row|
        acq_time = row['acq_time'].include?(':') ? row['acq_time'] : "#{row['acq_time'][0..1]}:#{row['acq_time'][2..3]}"
        detected_at = "#{row['acq_date']} #{acq_time}"
        lat_long = "#{row['latitude']},#{row['longitude']}"
        fire_identifier = Digest::SHA2.hexdigest "#{lat_long}#{detected_at}"

        next if Fire.find_by(identifier: fire_identifier).present?

        fire = Fire.new
        fire.identifier =  fire_identifier
        fire.lat_long   =  lat_long
        fire.scan_type  = scan_type.downcase
        fire.latitude   = row['latitude'].to_f
        fire.longitude  = row['longitude'].to_f
        fire.brightness = row['brightness']
        fire.bright_t31 = row['bright_t31']
        fire.bright_ti5 = row['bright_ti5']
        fire.bright_ti4 = row['bright_ti4']
        fire.scan       = row['scan']
        fire.track      = row['track']
        fire.frp        = row['frp']
        fire.satellite  = row['satellite']
        fire.confidence = row['confidence']
        fire.version    = row['version']
        fire.day_night  = row['day_night']
        fire.detected_at = detected_at.to_datetime
        fire.weather_reading_id = closest_weather_reading(fire).id

        fire.save
      end
    end

    def import_archive(start_int, end_int)
      #256, 315

      (start_int..end_int).each do |number|
        j_date = "2018#{number}".to_i

        FIRMS_DATA_URLS.each do |key, url|
          csv_text = fetch_data(key, url, j_date)
          parse_and_create(csv_text: csv_text, scan_type: key)
        end
      end
    end

    private

    def fetch_data(key, url, j_date)
      response = data_client.get do |req|
        req.url "#{url}#{j_date}.txt"
        req.headers['Authorization'] = "Bearer #{Rails.application.credentials[:nasa_api][:key]}"
      end

      response
    end

    def julian_date
      @julian_date ||= "#{Date.today.year}#{Date.today.yday}".to_i
    end

    def closest_weather_reading(fire)
      station = fetch_weather_station(fire.latitude, fire.longitude)
      range_start = (fire.detected_at - 30.minutes)
      range_end   = (fire.detected_at + 30.minutes)
      readings    = station.weather_readings.where(reading_at: range_start..range_end).order(:reading_at)

      return readings.first if readings.present?

      station.weather_readings.order(:reading_at).last
      # Uncomment when request opensource
      # readings = fetch_historical_data("/data/2.5/history/city?lat=#{station.latitude}&lon=#{station.longitude}&start=#{range_start.to_i}&end=#{range_end.to_i}")
    end

    def fetch_weather_station(latitude, longitude)
      closet_station = WeatherStation.closest(origin: [latitude, longitude]).first

      return closet_station if closet_station.present?

      WeatherStation.within(50, origin: [latitude, longitude]).first
    end

    def fetch_historical_data(url)
      response = historical_data_client.get do |req|
        req.url "#{url}&appid=#{Rails.application.credentials[:openweather_api][:key]}"
      end
      JSON.parse(response.body) if response.success?
    end

    def data_client
      @data_client ||= Faraday.new(:url => 'https://nrt4.modaps.eosdis.nasa.gov')
    end

    def historical_data_client
      @historical_data_client ||= Faraday.new(url: 'http://api.openweathermap.org')
    end
  end
end