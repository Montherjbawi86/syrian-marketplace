class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :phone, :city_id, :jobseeker, :company])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :phone, :city_id, :bio, :jobseeker, :company])
  end

  private

  def set_locale
    I18n.locale = :ar
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
