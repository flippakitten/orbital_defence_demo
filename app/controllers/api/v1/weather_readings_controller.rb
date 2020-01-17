class Api::V1::WeatherReadingsController < ApplicationController

  def show
    reading = WeatherStation.find(params['id'].to_i).weather_readings.last
    render json: reading.to_json, status: :ok
  end

  private

  def fire_params
    params.permit(:id)
  end
end
