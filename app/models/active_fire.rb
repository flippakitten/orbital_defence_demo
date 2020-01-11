class ActiveFire < ApplicationRecord
  def create_fires_with_readings
    fires = Fire.in_bounds([sw_bound_point, ne_bound_point]).where(detected_at: 24.hours.ago..Time.now)
    fires_with_weather = []
    fires.each do |fire|
      detected_at_weather = fire.detected_at_weather
      if detected_at_weather.present?
        detected_at_weather_endpoint = fire.endpoint(detected_at_weather.wind_direction, 2)

        current_weather = detected_at_weather.weather_station.weather_readings.last
        endpoint = fire.endpoint(current_weather.wind_direction, 2)
      end

      fires_with_weather << {
          fire: fire,
      }.tap do |params|
        return if current_weather.blank?

        params[:weather] = current_weather
        params[:detected_wind_arrow] = { lat: detected_at_weather_endpoint.lat, lng: detected_at_weather_endpoint.lng }
        params[:wind_arrow] = { lat: endpoint.lat, lng: endpoint.lng }
      end
    end

    ActiveFire.create(json: fires_with_weather.to_json, country: 'AUS')
  end

  def sw_bound_point
    @sw_bound_point ||= Geokit::LatLng.new(-39.840939, 112.913654)
  end

  def ne_bound_point
    @ne_bound_point ||= Geokit::LatLng.new(-11.332735, 154.103939)
  end
end
