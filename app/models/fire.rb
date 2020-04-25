class Fire < ApplicationRecord
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  belongs_to :weather_station
  has_many :weather_readings, through: :weather_station

  validates :identifier, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  scope :in_last_24_hours, -> { where(detected_at: (Time.now - 24.hours)..Time.now) }

  class << self
    def create_from_csv_row(row, scan_type)
      acq_time = row['acq_time'].include?(':') ? row['acq_time'] : "#{row['acq_time'][0..1]}:#{row['acq_time'][2..3]}"
      detected_at = "#{row['acq_date']} #{acq_time}"
      lat_long = "#{row['latitude']},#{row['longitude']}"
      fire_identifier = Digest::SHA2.hexdigest "#{lat_long}#{detected_at}"

      return if Fire.find_by(identifier: fire_identifier).present?

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

      station, reading = FireWeatherData.new(fire).find_or_create_weather
      fire.update_attributes(weather_reading_id: reading.id, weather_station: station)
      fire.save
    end
  end

  def detected_at_weather
    WeatherReading.find_by(id: weather_reading_id)
  end
end
