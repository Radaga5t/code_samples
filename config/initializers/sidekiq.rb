redis_config = Rails.application.config_for(:redis)

redis_cache_config = {
  compress: true,
  driver: :hiredis,
  host: redis_config['host'],
  port: redis_config['port'],
  db: 1
}
redis_cache_config[:password] = redis_config['password'] if redis_config['password'].present?

Sidekiq.configure_server do |config|
  config.redis = redis_cache_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_cache_config
end

schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq::Extensions.enable_delay!
