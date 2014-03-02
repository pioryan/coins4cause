require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Coins4Cause
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.initialize_on_precompile = false

    config.generators do |g|
      g.test_framework :rspec
    end
    config.generators do |g|
      g.template_engine :haml
    end

    config.twitter = if Rails.env.production?
                        {
                            key: ENV['C4C_TWT_KEY'],
                            secret: ENV['C4C_TWT_SECRET'],
                            access_token: ENV['C4C_TWT_ACCESS_TOKEN'],
                            access_token_secret: ENV['C4C_TWT_ACCESS_TOKEN_SECRET'],
                        }
                      else
                        YAML.load_file(Rails.root + "config/twitter.yml")[Rails.env].symbolize_keys
                      end
    def twitter
      config.twitter
    end

    def coinbase_key
      ENV['COINBASE_KEY']
    end
  end
end
