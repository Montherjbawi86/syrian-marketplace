class JobApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :whatsapp]

  def show
  end

  def whatsapp
    @message = "السلام عليكم، أنا أتقدم لوظيفة #{@application.listing.title_ar}%0a"
    @message += "الاسم: #{@application.name}%0a"
    @message += "البريد: #{@application.email}%0a"
    @message += "الهاتف: #{@application.phone}%0a%0a"
    @message += "#{@application.cover_letter}"
    
    whatsapp_url = "https://wa.me/#{@application.listing.user.phone.gsub(/[^0-9+]/, '')}?text=#{@message}"
    redirect_to whatsapp_url, allow_other_host: true
  end

  private

  def set_application
    @application = JobApplication.find(params[:id])
  end
end
