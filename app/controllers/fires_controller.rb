class FiresController < ApplicationController
  def index
    # fires = Fire.within(fire_params[:distance], origin: [fire_params[:latitude], fire_params[:longitude]])
    ne_point  = Geokit::LatLng.new(-33.638043945384716, 23.595538846778027)
    sw_point = Geokit::LatLng.new(-34.14418624060119, 22.277179471778027)

    fires = Fire.in_bounds([sw_point, ne_point]).all

    render json: fires.to_json, status: :ok
  end

  private

  def fire_params
    params.permit(:latitude, :longitude, :distance)
  end
end
