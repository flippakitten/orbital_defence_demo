class ImportModis
  require 'csv'

  class << self
    def import(file:, scan_type:)
      # MODIS_C6_Southern_Africa_24h.csv
      # VNP14IMGTDL_NRT_Southern_Africa_24h.csv
      csv_text = File.read(Rails.root.join('external_data', file))
      csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
      csv.each do |row|
        acq_time = "#{row['acq_time'][0..1]}:#{row['acq_time'][2..3]}"

        detected_at = "#{row['acq_date']} #{acq_time}"
        fire = Fire.new
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
        fire.detected_at = detected_at

        fire.save
      end
    end
  end
end