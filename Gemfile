source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'
gem 'dotenv-rails', '~> 2.7.4', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.3'
gem 'puma', '~> 3.11'

gem 'rails-i18n', '~> 5.1'

gem 'pg', '>= 0.18', '< 2.0'
gem 'store_model'
gem 'store_attribute', '~> 0.5.0'
gem 'pundit', '>= 2.0.0'
gem 'kaminari'
gem 'bson'
gem 'bson_ext'
gem 'geocoder'
gem 'pg_search'

gem 'google_drive', '3.0.4'

gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'globalize-accessors'
gem 'http_accept_language'
gem 'rails_admin_globalize_field'
gem 'google-cloud-translate'

gem 'money-rails', '~>1.12'
gem 'monetize'
gem 'eu_central_bank'

gem 'devise'
gem 'devise_token_auth'
# gem 'devise-async'
gem 'omniauth', '~> 1.9.0'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin-oauth2'

gem 'jbuilder', '~> 2.5'
gem 'oj'
gem 'oj_mimic_json'
gem 'versionist'
gem 'fast_jsonapi'
gem 'jsonapi.rb'
gem 'ransack'
gem 'active_model_serializers', '~> 0.10.0'

gem 'redis', '~> 4.0'
gem 'hiredis'
gem 'sidekiq', '~> 5.2.7'
gem 'sidekiq-cron', '~> 1.1'

gem 'sitemap_generator'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
gem 'carrierwave', '~> 1.0'
gem 'rails-assets-jcrop', source: 'https://rails-assets.org'
gem 'colorscore' ## getting dominant colors from image
gem 'file_validators'
gem 'rails_admin', '~> 1.4'
gem 'ckeditor', '~> 4.2'
gem 'rails_admin_softwarebrothers_theme', :git => 'https://github.com/SoftwareBrothers/rails_admin_softwarebrothers_theme'

gem 'punching_bag'
gem 'meta-tags'
gem 'simple_form'
gem 'jquery-rails'
gem 'fast-polylines' # https://github.com/klaxit/fast-polylines

gem 'faraday', '0.15.4'
gem 'faraday_middleware', '0.13.1'
gem 'nokogiri'
gem 'excon'

gem 'rack-cors', :require => 'rack/cors'
gem 'strings'
gem 'unicode_utils'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'sass-rails', '~> 5.0'

gem 'concurrent-ruby', require: 'concurrent'
gem 'roo', '~> 2.7.0'

gem 'anycable-rails'
gem 'anyway_config', '1.4.4'

gem 'sentry-raven'
gem 'newrelic_rpm'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 4.1'
  gem 'faker', '>= 2.0.0'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'fuubar', '>= 2.4.1'
  gem 'pronto'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'pronto-rubocop'
  gem 'pundit-matchers', '~> 1.6.0'
  gem 'awesome_pry'
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rb-readline'
  gem 'letter_opener'
  gem 'rails-erd'
  gem 'capistrano', require: false
  gem 'ed25519'
  gem 'bcrypt_pbkdf'

  # Profiling
  # gem 'rack-mini-profiler'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
