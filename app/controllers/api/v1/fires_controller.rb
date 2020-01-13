class Api::V1::FiresController < ApplicationController

  def index
    render json: ActiveFire.last.json, status: :ok
  end

  private

  def fire_params
    params.permit(:latitude, :longitude, :distance, :sw_bound_point, :ne_bound_point, :bust_cache)
  end
end
