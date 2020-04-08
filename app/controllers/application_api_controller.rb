# frozen_string_literal: true

# Рутовый api контроллер
class ApplicationApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  ## JSONAPI
  include JSONAPI::Errors
  include JSONAPI::Pagination
  include JSONAPI::Filtering
  include JSONAPI::Fetching
  include JSONAPI::Deserialization

  ## JSONAPI helpers
  include ApiResponse
  include ApiResponseErrors

  before_action :set_locale
  before_action :generate_guest_session
  before_action :set_raven_context

  private

  def set_locale
    I18n.locale = params[:locale] ||
                  http_accept_language.compatible_language_from(
                    I18n.available_locales
                  ) ||
                  I18n.default_locale

    globalize_fix
  end

  def current_user
    @current_user ||= super
    @current_user ||= warden.user(scope: :user, run_callbacks: false)
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
