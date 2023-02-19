require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qquiz
  class Application < Rails::Application
    config.load_defaults 6.1
    config.eager_load_paths << Rails.root.join('lib')
    config.time_zone = 'Asia/Kolkata'
    config.active_record.default_timezone = :local
    config.generators.system_tests = nil
    config.x.app_config = config_for('custom/config')
    config.x.permission = config_for('custom/permission')
    config.autoload_paths += Dir[Rails.root.join('app', 'jobs', '**/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'mailers', '**/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '**/')]
  end
end
