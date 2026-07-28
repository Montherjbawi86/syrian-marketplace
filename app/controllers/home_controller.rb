class HomeController < ApplicationController
  def index
    @categories = Category.active.order(:name_ar).limit(12)
    @recent_listings = Listing.active
                              .includes(:user, :city)
                              .recent
                              .limit(8)
    @for_sale = Listing.for_sale
                      .active
                      .includes(:user, :city)
                      .recent
                      .limit(5)
    @for_rent = Listing.for_rent
                      .active
                      .includes(:user, :city)
                      .recent
                      .limit(5)
    @cities = City.active.order(:name_ar).limit(12)

    # Initialize Ransack search object
    @q = Listing.active.ransack(params[:q])
  end

  def about; end
  def contact; end
  def terms; end
  def privacy; end
  def how_it_works; end

  def send_contact
    # Add mailer here later
    redirect_to root_path, notice: 'تم إرسال رسالتك بنجاح'
  end
end
