class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.includes(:favoritable)
  end

  def create
    @favorite = current_user.favorites.build(favorite_params)

    if @favorite.save
      redirect_to @favorite.favoritable, notice: t('favorites.created')
    else
      redirect_back fallback_location: root_path, alert: t('favorites.error')
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: root_path, notice: t('favorites.destroyed')
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favoritable_id, :favoritable_type)
  end
end
