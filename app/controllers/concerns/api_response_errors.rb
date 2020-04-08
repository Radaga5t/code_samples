# frozen_string_literal: true

# Модуль с обработками исключений
module ApiResponseErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :render_jsonapi_forbidden
  end

  private

  # 401 exception handler
  #
  # @param exception [Exception] instance to handle
  # @return [String] JSONAPI error response
  def render_jsonapi_not_authorized(exception = nil)
    error = { status: '401', title: Rack::Utils::HTTP_STATUS_CODES[401] }
    render jsonapi_errors: [error], status: :not_authorized
  end

  # 403 Forbidden exception handler
  #
  # @param exception [Exception] instance to handle
  # @return [String] JSONAPI error response
  def render_jsonapi_forbidden(exception = nil)
    error = { status: '403', title: Rack::Utils::HTTP_STATUS_CODES[403] }
    render jsonapi_errors: [error], status: :forbidden
  end
end