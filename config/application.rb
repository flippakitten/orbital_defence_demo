require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FireAssist
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.autoload_paths << Rails.root.join('app', 'models', 'routing')
    config.load_defaults 5.2


    # rubocop:disable Security/YAMLLoad
    # REDIS_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result)
    # rubocop:enable Security/YAMLLoad
    # config.cache_store = :redis_cache_store, REDIS_CONFIG[Rails.env].merge(timeout: 10.minutes)
    cache_config = YAML.load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result)
    config.cache_store = :redis_cache_store, cache_config[Rails.env]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # Don't generate system test files.
    config.generators.system_tests = nil
    config.public_file_server.enabled = true
    config.api_only = true
  end
end
