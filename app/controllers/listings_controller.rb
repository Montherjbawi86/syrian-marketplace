class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite, :apply, :submit_application, :toggle_status]
  before_action :authenticate_user!, except: [:index, :show, :search, :jobs, :products, :for_sale, :for_rent, :wanted]
  before_action :check_ownership, only: [:edit, :update, :destroy, :toggle_status]

  def index
    @listings = Listing.active
                      .includes(:user, :city, :category)
                      .recent
                      .page(params[:page])
                      .per(24)
    @title = "جميع الإعلانات"
  end

  def jobs
    @listings = Listing.active
                      .joins(:category)
                      .where(categories: { category_type: 3 }) # jobs type
                      .includes(:user, :city)
                      .recent
                      .page(params[:page])
                      .per(24)
    @title = "وظائف"
    render :index
  end

  def products
    @listings = Listing.active
                      .joins(:category)
                      .where.not(categories: { category_type: 3 }) # not jobs
                      .includes(:user, :city)
                      .recent
                      .page(params[:page])
                      .per(24)
    @title = "منتجات"
    render :index
  end

  def for_sale
    @listings = Listing.active
                      .for_sale
                      .includes(:user, :city)
                      .recent
                      .page(params[:page])
                      .per(24)
    @title = "للبيع"
    render :index
  end

  def for_rent
    @listings = Listing.active
                      .for_rent
                      .includes(:user, :city)
                      .recent
                      .page(params[:page])
                      .per(24)
    @title = "للإيجار"
    render :index
  end

  def wanted
    @listings = Listing.active
                      .wanted
                      .includes(:user, :city)
                      .recent
                      .page(params[:page])
                      .per(24)
    @title = "مطلوب"
    render :index
  end

  def show
    @listing.increment!(:views_count)
    @similar_listings = @listing.similar_listings(6)
    @favorited = user_signed_in? ? current_user.favorites.exists?(listing: @listing) : false
  end

  def new
    @listing = Listing.new
    @categories = Category.all.order(:name_ar)
    @cities = City.all.order(:name_ar)
  end

  def create
    @listing = current_user.listings.new(listing_params)
    @listing.status = :active

    if @listing.save
      redirect_to @listing, notice: '✅ تم إنشاء الإعلان بنجاح'
    else
      @cities = City.active.order(:name_ar)
      @categories = Category.active.order(:name_ar)
      flash.now[:alert] = '❌ حدث خطأ في إنشاء الإعلان'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @cities = City.active.order(:name_ar)
    @categories = Category.active.order(:name_ar)
  end

  def update
    # Handle image removal
    if params[:remove_images].present?
      params[:remove_images].each do |image_id|
        image = @listing.images.find(image_id)
        image.purge
      end
    end

    if @listing.update(listing_params)
      redirect_to @listing, notice: '✅ تم تحديث الإعلان بنجاح'
    else
      @cities = City.active.order(:name_ar)
      @categories = Category.active.order(:name_ar)
      render :edit, status: :unprocessable_entity
    end
  end

def destroy
  if @listing.user == current_user || current_user&.admin?
    @listing.destroy
    redirect_to dashboard_listings_path, notice: '✅ تم حذف الإعلان بنجاح'
  else
    redirect_to @listing, alert: '❌ لا يمكنك حذف هذا الإعلان'
  end
end

  def search
    @listings = Listing.active

    if params[:q].present?
      @listings = @listings.where('title_ar ILIKE :q OR description_ar ILIKE :q', q: "%#{params[:q]}%")
    end

    if params[:category_id].present?
      @listings = @listings.where(category_id: params[:category_id])
    end

    if params[:city_id].present?
      @listings = @listings.where(city_id: params[:city_id])
    end

    if params[:min_price].present?
      @listings = @listings.where('price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @listings = @listings.where('price <= ?', params[:max_price])
    end

    @listings = @listings.includes(:user, :city, :category)
                        .recent
                        .page(params[:page])
                        .per(24)
    @title = "نتائج البحث عن: #{params[:q]}"
    render :index
  end

  def favorite
    @listing = Listing.find(params[:id])
    favorite = current_user.favorites.new(listing: @listing)

    if favorite.save
      redirect_to @listing, notice: '❤️ تمت الإضافة إلى المفضلة'
    else
      redirect_to @listing, alert: '❌ حدث خطأ'
    end
  end

  def unfavorite
    @listing = Listing.find(params[:id])
    favorite = current_user.favorites.find_by(listing: @listing)
    favorite&.destroy
    redirect_to @listing, notice: '💔 تمت الإزالة من المفضلة'
  end

  def apply
    @job_application = JobApplication.new
  end

  def submit_application
    @job_application = @listing.job_applications.new(job_application_params)
    @job_application.user = current_user if user_signed_in?
    @job_application.applied_via = :website

    if @job_application.save
      redirect_to whatsapp_job_application_path(@job_application)
    else
      render :apply, status: :unprocessable_entity
    end
  end

  def toggle_status
    if @listing.active?
      @listing.update(status: :expired)
      notice = '⏸️ تم إيقاف الإعلان مؤقتاً'
    else
      @listing.update(status: :active)
      notice = '✅ تم تفعيل الإعلان'
    end
    redirect_to dashboard_listings_path, notice: notice
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to listings_path, alert: 'الإعلان غير موجود'
  end

  def check_ownership
    unless @listing.user == current_user || current_user&.admin?
      redirect_to @listing, alert: '❌ لا يمكنك تعديل هذا الإعلان'
    end
  end

  def listing_params
    params.require(:listing).permit(
      :title, :title_ar, :description, :description_ar, :price,
      :condition, :listing_type, :status, :city_id, :category_id,
      :subcategory_id, :whatsapp_contact, :phone_contact, :email_contact,
      :featured, :urgent, images: []
    )
  end

  def job_application_params
    params.require(:job_application).permit(:name, :email, :phone, :cv, :cover_letter)
  end
end
