class ApiController < ApplicationController
  def category_subcategories
    @category = Category.find(params[:id])
    @subcategories = @category.subcategories.active
    render json: @subcategories.map { |s| { id: s.id, name_ar: s.name_ar } }
  end
end
