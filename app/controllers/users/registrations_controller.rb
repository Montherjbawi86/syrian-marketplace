class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @user_type = params[:type] || 'jobseeker'
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :phone, :city_id, :jobseeker, :company])
  end
end
