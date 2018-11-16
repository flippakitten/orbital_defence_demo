class FiresController < ApplicationController
  def index
    # fires = Fire.within(fire_params[:distance], origin: [fire_params[:latitude], fire_params[:longitude]])


    # fires = Fire.in_bounds([sw_point, ne_point]).all
    fires = Fire.in_bounds([sw_bound_point, ne_bound_point]).where(detected_at: 24.hours.ago..Time.now)
    fires_with_weather = []
    fires.each do |fire|
      weather = fire.detected_at_weather
      endpoint = fire.endpoint(weather.wind_direction, 2)

      fires_with_weather << {
        fire: fire,
        weather: weather,
        wind_arrow: { lat: endpoint.lat, lng: endpoint.lng }
      }
    end

    render json: fires_with_weather.to_json, status: :ok
  end

  private

  def fire_params
    params.permit(:latitude, :longitude, :distance, :sw_bound_point, :ne_bound_point)
  end

  def sw_bound_point
    @sw_bound_point ||= Geokit::LatLng.new(-34.14418624060119, 22.277179471778027)
  end

  def ne_bound_point
    @ne_bound_point ||= Geokit::LatLng.new(-33.638043945384716, 23.595538846778027)
  end
end
