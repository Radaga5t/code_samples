# frozen_string_literal: true

# Рутовый контроллер для всего приложения, от него наследуются все контроллеры
class ApplicationController < ActionController::Base
  include Pundit

  # для Devise
  protect_from_forgery prepend: true
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] ||
                  http_accept_language.compatible_language_from(
                    I18n.available_locales
                  ) ||
                  I18n.default_locale

    globalize_fix
  end

  def globalize_fix
    storage = RequestStore.store
    return if storage[:globalize_fallbacks].present?

    fallback_hash = HashWithIndifferentAccess.new
    { en: %i[en hu ru], hu: %i[hu en ru], ru: %i[ru hu en] }.each do |key, value|
      fallback_hash[key] = value.presence || [key]
    end
    storage[:globalize_fallbacks] = fallback_hash
  end
end
