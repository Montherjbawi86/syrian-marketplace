class CitiesController < ApplicationController
  def index
    @cities = City.active.order(:name_ar)
  end

  def show
    @city = City.find(params[:id])
    @listings = @city.listings.active
                    .includes(:user, :category, :city, :images_attachments)
                    .recent
                    .page(params[:page])
                    .per(24)
  end
end
