class Api::V1::FiresController < ApplicationController

  def index
    render json: populate_fires, status: :ok
  end

  private

  def populate_fires
    fires = Fire.in_bounds([sw_bound_point, ne_bound_point]).where(detected_at: 24.hours.ago..Time.now)
    fires_with_weather = []
    fires.each do |fire|
      detected_at_weather = fire.detected_at_weather
      detected_at_weather_endpoint = fire.endpoint(detected_at_weather.wind_direction, 2)

      current_weather = detected_at_weather.weather_station.weather_readings.last
      endpoint = fire.endpoint(current_weather.wind_direction, 2)

      fires_with_weather << {
          fire: fire,
          weather: current_weather,
          detected_wind_arrow: { lat: detected_at_weather_endpoint.lat, lng: detected_at_weather_endpoint.lng },
          wind_arrow: { lat: endpoint.lat, lng: endpoint.lng }
      }
    end

    fires_json = fires_with_weather.to_json
    fires_json
  end

  def fire_params
    params.permit(:latitude, :longitude, :distance, :sw_bound_point, :ne_bound_point, :bust_cache)
  end

  def sw_bound_point
    @sw_bound_point ||= Geokit::LatLng.new(-39.840939, 112.913654)
  end

  def ne_bound_point
    @ne_bound_point ||= Geokit::LatLng.new(-11.332735, 154.103939)
  end
end
