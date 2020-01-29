# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenWeatherApi::WeatherByCoordinates, type: :service do

  context '#fetch_weather_by_coordinates', :vcr  do
    let(:latitude) { '1' }
    let(:longitude) { '1' }
    let(:station_data) { OpenWeatherApi::WeatherByCoordinates.fetch(latitude: latitude, longitude: longitude) }

    it 'returns json data as a hash' do
      expect(station_data).to be_a(Hash)
    end
  end
end
