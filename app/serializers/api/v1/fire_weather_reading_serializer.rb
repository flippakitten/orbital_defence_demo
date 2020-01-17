class Api::V1::FireSerializer < ActiveModel::Serializer
  attributes :id,

  def id
    object.id.to_s
  end

  def weather_reading_id
    object.weather_reading_id.to_s
  end
end