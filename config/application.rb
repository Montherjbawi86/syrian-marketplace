require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SyrianMarketplace
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.default_locale = :ar
    config.i18n.available_locales = [:ar, :en]
    config.time_zone = 'Asia/Damascus'
    config.active_record.default_timezone = :local
  end
end
