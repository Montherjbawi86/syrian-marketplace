class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @stats = {
      total_listings: current_user.listings.count,
      active_listings: current_user.listings.active.count,
      total_views: current_user.listings.sum(:views_count),
      total_favorites: current_user.listings.joins(:favorites).count,
      unread_messages: current_user.unread_messages_count
    }
    @recent_listings = current_user.listings.recent.limit(5)
  end

  def listings
    @listings = current_user.listings.recent.page(params[:page]).per(10)
  end

  def jobs
    @listings = current_user.listings.jobs.recent.page(params[:page]).per(10)
    render :listings
  end

  def applications
    @applications = JobApplication.where(listing: current_user.listings)
                                  .order(created_at: :desc)
                                  .page(params[:page]).per(20)
  end

  def messages
    @conversations = Conversation.where('buyer_id = ? OR seller_id = ?', current_user.id, current_user.id)
                                 .includes(:listing, :buyer, :seller)
                                 .order(updated_at: :desc)
                                 .page(params[:page]).per(20)
  end

 # app/controllers/dashboard_controller.rb
def favorites
  @favorites = current_user.favorites.includes(listing: [:images_attachments, :user, :city]).page(params[:page]).per(12)
end

  def settings
    @user = current_user
  end

  def update_settings
    @user = current_user
    if @user.update(user_params)
      redirect_to dashboard_settings_path, notice: 'تم تحديث الإعدادات بنجاح'
    else
      render :settings
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :phone, :city_id, :bio, :jobseeker, :company)
  end
end
