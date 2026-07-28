# app/controllers/jobs_controller.rb
class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_job, only: [:show, :seeker, :edit, :update, :destroy]
  before_action :check_company, only: [:new, :create, :edit, :update, :destroy]

  # GET /jobs
 # app/controllers/jobs_controller.rb
    def index
      @job_listings = Listing.jobs.active.includes(:user, :city, :category, :subcategory)

      # Apply filters
      @job_listings = @job_listings.where(city_id: params[:city_id]) if params[:city_id].present?
      @job_listings = @job_listings.where(category_id: params[:category_id]) if params[:category_id].present?
      @job_listings = @job_listings.where(subcategory_id: params[:subcategory_id]) if params[:subcategory_id].present?

      @job_listings = @job_listings.order(created_at: :desc).page(params[:page]).per(6)

      @job_seekers = User.where(jobseeker: true).includes(:city)
      @job_seekers = @job_seekers.where(city_id: params[:city_id]) if params[:city_id].present?
      @job_seekers = @job_seekers.order(created_at: :desc).limit(6)

      @categories = Category.where(category_type: 3).includes(:subcategories)
      @subcategories = Subcategory.joins(:category).where(categories: { category_type: 3 }).active
    end
  # GET /jobs/listings
  def listings
    @jobs = Listing.jobs.active
                   .includes(:user, :city, :subcategory)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(12)

    # Apply filters
    @jobs = @jobs.where(subcategory_id: params[:subcategory_id]) if params[:subcategory_id].present?
    @jobs = @jobs.where(city_id: params[:city_id]) if params[:city_id].present?
    @jobs = @jobs.where("price >= ?", params[:min_salary]) if params[:min_salary].present?
    @jobs = @jobs.where("price <= ?", params[:max_salary]) if params[:max_salary].present?

    @subcategories = Subcategory.joins(:category).where(categories: { category_type: 3 }).active
    @cities = City.active
  end

  # GET /jobs/seekers
  def seekers
    @seekers = User.where(jobseeker: true)
                   .includes(:city)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(12)

    @cities = City.active
  end

  # GET /jobs/new
  def new
    @job = Listing.new
    @job.listing_type = 'job'
    @categories = Category.where(category_type: 3) # Jobs category
  end

  # POST /jobs
  def create
    @job = current_user.listings.new(job_params)
    @job.listing_type = 'job'
    @job.status = 'active'

    # ✅ للتشخيص - معرفة البيانات القادمة
    Rails.logger.debug "=" * 50
    Rails.logger.debug "Job Params: #{job_params.inspect}"
    Rails.logger.debug "=" * 50

    if @job.save
      redirect_to job_path(@job), notice: 'تم نشر الوظيفة بنجاح'
    else
      @categories = Category.where(category_type: 3)

      # ✅ عرض الأخطاء للتشخيص
      Rails.logger.debug "Job Errors: #{@job.errors.full_messages}"

      render :new, status: :unprocessable_entity
    end
  end

  # GET /jobs/:id
  def show
    @job = Listing.jobs.active.find(params[:id])
    @similar_jobs = Listing.jobs.active
                           .where(subcategory_id: @job.subcategory_id)
                           .where.not(id: @job.id)
                           .order(created_at: :desc)
                           .limit(3)
    # Increment view count
    @job.increment!(:views_count) if @job.respond_to?(:views_count)
  end

  # GET /jobs/:id/edit
  def edit
    # @job is set by before_action
  end

  # PATCH/PUT /jobs/:id
  def update
    if @job.update(job_params)
      redirect_to job_path(@job), notice: 'تم تحديث الوظيفة بنجاح'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /jobs/:id
  def destroy
    @job.destroy
    redirect_to jobs_path, notice: 'تم حذف الوظيفة بنجاح'
  end

  # GET /jobs/:id/seeker
  def seeker
    @seeker = User.where(jobseeker: true).find(params[:id])
  end

  private

  def set_job
    @job = Listing.jobs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jobs_path, alert: 'الوظيفة غير موجودة'
  end

  def check_company
    unless current_user.company?
      redirect_to jobs_path, alert: 'يجب أن تكون مسجلاً كشركة لنشر وظائف'
    end
  end

  # ✅ تأكد من وجود description_ar هنا
  def job_params
    params.require(:listing).permit(
      :title_ar, :title,
      :description_ar, :description,  # ✅ يجب أن يكونا موجودين
      :requirements, :benefits, :skills,
      :job_type, :experience_level, :deadline,
      :price, :category_id, :subcategory_id, :city_id,
      :whatsapp_contact, :phone_contact, :email_contact
    )
  end
end
