require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require 'yaml'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FinalProject
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework nil
      g.factory_bot false
      g.scaffold_stylesheet false
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.autoload_paths += %W(#{config.root}/vendor/app/models)
    
    add_to_env = YAML.load_file(File.join(Rails.root,'sensitive_info.yaml'))

    add_to_env.each do |k, v|
      ENV[k] = v
    end
    
    # Set up mailer configuration
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_options = {from: 'ts.appdev.project@gmail.com'}
    config.action_mailer.smtp_settings = {
        :user_name => ENV["SENDGRID_USERNAME"],
        :password => ENV["SENDGRID_PASSWORD"],
        :domain => 'gmail.com',
        :address => 'smtp.sendgrid.net',
        :port => 587,
        :authentication => :plain,
        :enable_starttls_auto => true
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_record.belongs_to_required_by_default = false
  end
end
