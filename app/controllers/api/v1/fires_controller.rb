class Api::V1::FiresController < ApplicationController
  include Pagy::Backend
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    @pagy, @records = pagy(Fire.in_last_24_hours, items: 300)

    render json: { data: @records }, status: :ok, each_serializer: Api::V1::FireSerializer
  end

  def search
    render json: fires_in_bounds, status: :ok, each_serializer: Api::V1::FireSerializer
  end

  def fires_current_wind_direction_indicator

    wind_indicators = fires_in_bounds.map do |fire|
      current_weather = fire.weather_station.weather_readings.last
      endpoint = fire.endpoint(current_weather.wind_direction, 2)
      {
        fire: { lat: fire.latitude, lng: fire.longitude },
        wind: { lat: endpoint.lat, lng: endpoint.lng }
      }
    end

    render json: wind_indicators, status: :ok
  end

  private

  def fire_params
    params.permit(:sw_bound_point, :ne_bound_point)
  end

  def fires_in_bounds
    @fires_in_bounds ||= Fire.in_last_24_hours.in_bounds([sw_bound_point, ne_bound_point])
  end
  def sw_bound_point
    @sw_bound_point ||= Geokit::LatLng.new(get_lat(sw_lat_lng), get_lng(sw_lat_lng))
  end

  def ne_bound_point
    @ne_bound_point ||= Geokit::LatLng.new(get_lat(ne_lat_lng), get_lng(ne_lat_lng))
  end

  def ne_lat_lng
    params['ne_bound_point']
  end

  def sw_lat_lng
    params['sw_bound_point']
  end

  def get_lat(string)
    string.split(',').first.to_f
  end

  def get_lng(string)
    string.split(',').last.to_f
  end
end
