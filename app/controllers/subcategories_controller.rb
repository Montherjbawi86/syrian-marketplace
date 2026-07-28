class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show]

  def index
    @subcategories = Subcategory.includes(:category)
                                .order(:name_ar)
                                .page(params[:page])
                                .per(24)
    
    # Get all categories for filtering
    @categories = Category.all.order(:name_ar)
    
    # Apply category filter if present
    if params[:category_id].present?
      @subcategories = @subcategories.where(category_id: params[:category_id])
    end
    
    # Apply search filter if present
    if params[:q].present?
      @subcategories = @subcategories.where('name_ar ILIKE :q', q: "%#{params[:q]}%")
    end
  end

  def show
    # Base query - active listings in this subcategory
    @listings = @subcategory.listings.active
                              .includes(:user, :city, :category, :images_attachments)

    # Apply type filter if present
    if params[:type].present?
      @listings = @listings.where(listing_type: params[:type])
    end

    # Apply condition filter if present
    if params[:condition].present?
      @listings = @listings.where(condition: params[:condition])
    end

    # Apply price range filters
    if params[:min_price].present?
      @listings = @listings.where('price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @listings = @listings.where('price <= ?', params[:max_price])
    end

    # Apply city filter if present
    if params[:city_id].present?
      @listings = @listings.where(city_id: params[:city_id])
    end

    # Order and paginate
    @listings = @listings.recent.page(params[:page]).per(24)

    # Get filter options for the sidebar
    @cities = City.active.order(:name_ar)
    @conditions = Listing.conditions.keys if defined?(Listing.conditions)

    # Set title based on filter
    @title = case params[:type]
    when 'sell'
      "#{@subcategory.name_ar} للبيع"
    when 'rent'
      "#{@subcategory.name_ar} للإيجار"
    when 'wanted'
      "#{@subcategory.name_ar} مطلوب"
    when 'job'
      "وظائف في #{@subcategory.name_ar}"
    else
      @subcategory.name_ar
    end
  end

  private

  def set_subcategory
    @subcategory = Subcategory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to subcategories_path, alert: 'التصنيف الفرعي غير موجود'
  end
end
