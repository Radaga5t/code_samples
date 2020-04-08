RailsAdmin::Config::Fields::Types::register(:pg_array, QjobAdmin::FieldTypes::PgArray)
RailsAdmin.config do |config|
  require 'i18n'
  I18n.default_locale = :ru
  QjobAdmin::General.new.add_to_config(config)
  QjobAdmin::Models.new.add_to_config(config)
end
