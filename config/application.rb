require File.expand_path('boot', __dir__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SmWorkflowLims
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

    config.load_defaults 7.0

    config.mailer = YAML.load_file(Rails.root.join('config/mailer.yml').to_s)[Rails.env]
    config.autoload_paths += %W[#{config.root}/lib/utils]
    config.disable_animations = false

    config.autoload_paths += %W[#{Rails.root.join('app/presenters')}]
    config.eager_load_paths += %W[#{Rails.root.join('app/presenters')}]

    # Enabling the behaviour where 'belongs_to' associations are required by default.
    # (https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option)
    config.active_record.belongs_to_required_by_default = true

    config.action_controller.default_protect_from_forgery = false
  end
end
