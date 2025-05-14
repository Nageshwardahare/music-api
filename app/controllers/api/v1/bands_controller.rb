class Api::V1::BandsController < ApplicationController
  def index
    if params[:city].blank?
      return render json: { error: "City is required" }, status: :unprocessable_entity
    end

    bands = MusicbrainzService.new(params[:city]).fetch_recent_bands
    render json: bands
  end
end
