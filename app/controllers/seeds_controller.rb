class SeedsController < ApplicationController
  def run
    load Rails.root.join('db', 'seeds.rb')
    render plain: '✅ تم تشغيل الـ Seeds بنجاح!', status: :ok
  rescue => e
    render plain: "❌ خطأ: #{e.message}", status: :internal_server_error
  end
end
