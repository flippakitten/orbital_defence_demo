class Fire < ApplicationRecord
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  validates :identifier, uniqueness: true

  def detected_at_weather
    WeatherReading.find_by(id: weather_reading_id)
  end
end
