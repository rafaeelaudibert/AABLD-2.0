require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aabld
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Logger
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
    config.logger.level = Logger::ERROR

    # Locales
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = [:'pt-BR']
    config.i18n.default_locale = :'pt-BR'

    # Timezone
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :utc

    # Add Google Maps API key
    config.google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY'] || ''

    # Stylesheet generation conflict
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
  end
end
