class WeatherReading < ApplicationRecord
  belongs_to :weather_station

  validates :identifier, uniqueness: true

  after_find :convert_temprature

  private

  def convert_temprature
    self.temprature = self.temprature - 273.15
  end
end
