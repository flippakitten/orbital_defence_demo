class ImportFirmsData
  require 'csv'
  FIRMS_DATA_URLS = {
    modis: '/api/v2/content/archives/FIRMS/c6/Australia_NewZealand/MODIS_C6_Australia_NewZealand_MCD14DL_NRT_',
    virrs: '/api/v2/content/archives/FIRMS/viirs/Australia_NewZealand/VIIRS_I_Australia_NewZealand_VNP14IMGTDL_NRT_'
    #modis: '/api/v2/content/archives/FIRMS/c6/Southern_Africa/MODIS_C6_Southern_Africa_MCD14DL_NRT_',
    #viirs: '/api/v2/content/archives/FIRMS/viirs/Southern_Africa/VIIRS_I_Southern_Africa_VNP14IMGTDL_NRT_'
  }

  class << self
    def import
      FIRMS_DATA_URLS.each do |key, url|
        response = fetch_data(url)
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

        fire = Fire.create(
          identifier: fire_identifier,
          lat_long:   lat_long,
          scan_type:  scan_type.downcase,
          latitude:   row['latitude'].to_f,
          longitude:  row['longitude'].to_f,
          brightness: row['brightness'],
          bright_t31: row['bright_t31'],
          bright_ti5: row['bright_ti5'],
          bright_ti4: row['bright_ti4'],
          scan:       row['scan'],
          track:      row['track'],
          frp:        row['frp'],
          satellite:  row['satellite'],
          confidence: row['confidence'],
          version:    row['version'],
          day_night:  row['day_night'],
          detected_at: detected_at.to_datetime,
        )

        station, reading = fetch_weather_data(fire)
        fire.update_attributes(weather_reading_id: reading.id)
        fire.weather_station = station
        fire.save!
      end
    end

    private

    def fetch_data(url)
      response = data_client.get do |req|
        req.url "#{url}#{julian_date}.txt"
        req.headers['Authorization'] = "Bearer #{Rails.application.credentials[:nasa_api][:key]}"
      end

      response
    end

    def julian_date
      @julian_date ||= "#{Date.today.year}#{"%.3d" % Date.today.yday}".to_i
    end

    def fetch_weather_data(fire)
      station = WeatherStation.within(10, origin: [fire.latitude, fire.longitude]).first

      if station.present?
        latest_reading = station.weather_readings.last

        return station, latest_reading if latest_reading&.reading_at.between?(fire.detected_at - 30.minutes, fire.detected_at + 30.minutes)
      end

      ImportOpenweatherData.new(fire).fetch_reading_and_create_station_data
    end

    def data_client
      @data_client ||= Faraday.new(url: 'https://nrt4.modaps.eosdis.nasa.gov')
    end
  end
end