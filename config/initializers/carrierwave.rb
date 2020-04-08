CarrierWave.configure do |config|
  config.ignore_integrity_errors = Rails.env.production?
  config.ignore_processing_errors = Rails.env.production?
  config.ignore_download_errors = Rails.env.production?
  config.asset_host = ActionController::Base.asset_host
end
