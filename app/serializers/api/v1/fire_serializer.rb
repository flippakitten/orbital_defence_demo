class Api::V1::FireSerializer < ActiveModel::Serializer
  attributes :id, :scan_type, :detected_at, :confidence, :latitude, :longitude, :weather_reading_id

  def id
    object.id.to_s
  end

  def weather_reading_id
    object.weather_reading_id.to_s
  end
end