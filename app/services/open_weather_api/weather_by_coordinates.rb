# frozen_string_literal: true

module OpenWeatherApi
  class WeatherByCoordinates
    API_THROTTLE_TIME = (ENV['API_THROTTLE_TIME'] || 0.02).freeze

    class << self
      def fetch(latitude:, longitude:)
        response = open_weather_client.get do |req|
          req.url "/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{open_weather_key}"
        end

        sleep API_THROTTLE_TIME

        JSON.parse(response.body) if response.success?
      end

      private

      def open_weather_client
        @open_weather_client ||= Faraday.new(url: 'http://api.openweathermap.org')
      end

      def open_weather_key
        @open_weather_key ||= Rails.application.credentials[:openweather_api][:key]
      end
    end
  end
end
