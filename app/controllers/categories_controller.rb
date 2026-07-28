class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :subcategories]

  def index
    @categories = Category.all.order(:name_ar)
  end

  def show
    # Get all subcategories for this category
    @subcategories = @category.subcategories.order(:name_ar)

    # Get listings in this category (through subcategories)
    @listings = Listing.where(category_id: @category.id)
                       .or(Listing.where(subcategory_id: @subcategories.pluck(:id)))
                       .active
                       .recent
                       .page(params[:page])
                       .per(24)
  end

  def subcategories
    @subcategories = @category.subcategories.order(:name_ar)
    render json: @subcategories
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to categories_path, alert: 'التصنيف غير موجود' }
      format.json { render json: { error: 'Category not found' }, status: :not_found }
    end
  end
end
