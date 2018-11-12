class ImportFirmsData
  require 'csv'
  FIRMS_DATA_URLS = {
    modis: '/api/v2/content/archives/FIRMS/c6/Southern_Africa/MODIS_C6_Southern_Africa_MCD14DL_NRT_',
    viirs: '/api/v2/content/archives/FIRMS/viirs/Southern_Africa/VIIRS_I_Southern_Africa_VNP14IMGTDL_NRT_'
  }
  class << self
    def import
      FIRMS_DATA_URLS.each do |key, url|
        csv_text = fetch_data(key, url, julian_date)
        parse_and_create(csv_text: csv_text, scan_type: key)
      end
    end

    def import_file(file:, scan_type:)
      csv_text = File.read(Rails.root.join('external_data', file))
      parse_and_create(csv_text: csv_text, scan_type: scan_type)
    end

    def parse_and_create(csv_text:, scan_type:)
      csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
      csv.each do |row|
        acq_time = "#{row['acq_time'][0..1]}:#{row['acq_time'][2..3]}"
        lat_long = "#{row['latitude']},#{row['longitude']}"
        detected_at = "#{row['acq_date']} #{acq_time}"

        fire = Fire.new
        fire.identifier =  Digest::SHA2.hexdigest "#{lat_long}#{detected_at}"
        fire.lat_long   =  lat_long
        fire.scan_type  = scan_type.downcase
        fire.latitude   = row['latitude']
        fire.longitude  = row['longitude']
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

      if response.success?
        response.body
      end
    end

    def data_client
      @data_client ||= Faraday.new(:url => 'https://nrt4.modaps.eosdis.nasa.gov')
    end

    def julian_date
      @julian_date ||= "#{Date.today.year}#{Date.today.yday}".to_i
    end
  end
end