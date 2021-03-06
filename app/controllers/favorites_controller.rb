class FavoritesController < ApplicationController
  before_action :set_favorite, only: :destroy

  def index
    @startups = Startup.geocoded # returns startups with coordinates
    @markers = @startups.map do |startup|
      {
        lat: startup.latitude,
        lng: startup.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { startup: startup })
        # image_url: helpers.asset_url('lewagon-logo-square')
      }
    end
  end

  def create
    @favorite = Favorite.new
    @favorite.startup = Startup.find(params[:startup_id])
    @favorite.user = current_user
    if @favorite.save
      redirect_to startup_path(@favorite.startup)
    else
      redirect_to request.referrer
    end
  end

  def destroy
    @favorite.destroy

    redirect_to startup_path(@favorite.startup)
  end

  private

  # def set_user
  #   @user = User.find(params[:id])
  # end

  def set_favorite
    @favorite = Favorite.find(params[:id])
  end

  def favorite_params
    params.require(:favorite).permit(:startup_id)
  end
end
