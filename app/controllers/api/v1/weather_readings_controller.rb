class Api::V1::WeatherReadingsController < ApplicationController

  def show
    reading = WeatherReading.find(params['id'].to_i)
    render json: reading.to_json, status: :ok
  end

  private

  def fire_params
    params.permit(:id)
  end
end
