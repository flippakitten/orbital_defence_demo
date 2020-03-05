# frozen_string_literal: true

require 'sidekiq-scheduler'
require 'sidekiq-scheduler/web'
require_dependency 'config_parser'

config_path = Rails.root.join 'config', 'redis_sidekiq.yml'
redis_conf = ConfigParser.parse config_path, Rails.env

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end

Sidekiq.configure_server do |config|
  config.redis = redis_conf

  config.on(:startup) do
    schedule_path = Rails.root.join 'config', 'sidekiq_schedule.yml'
    Sidekiq.schedule = ConfigParser.parse schedule_path, Rails.env
    Sidekiq::Scheduler.reload_schedule!
  end
end

Sidekiq.default_worker_options = { backtrace: true }
