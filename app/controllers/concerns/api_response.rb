# frozen_string_literal: true

require Rails.root.join('app', 'serializers', 'json_api_serializers', 'api_error_serializer')

# Хелперы для работы с API ответами
module ApiResponse
  attr_accessor :jsonapi_response_meta
  attr_accessor :jsonapi_serializer

  # рендер JSON
  def json_response(object, status: :ok, options: {})
    if request.content_type == JSONAPI_MEDIA_TYPE || request.headers['Accept'].include?(JSONAPI_MEDIA_TYPE)
      json_api_response(object, options: options, status: status)
    else
      ams_json_response(object, status: status, options: options)
    end
  end

  private

  # ответ в виде чистого JSON
  def ams_json_response(object, status: :ok, options: {})
    render({ json: object, status: status }.merge(options))
  end

  # ответ в виде объекта JSON по стандарту JSON:API
  def json_api_response(object, status: :ok, options: {})
    if !object.respond_to?(:errors) || object&.errors.blank?
      render jsonapi: object, status: status
    else
      render jsonapi_errors: object.errors,
             status: :unprocessable_entity
    end
  end

  def jsonapi_serializer_params
    @jsonapi_serializer_params ||= {
      current_user: current_user
    }
  end

  def jsonapi_serializer_class(resource, is_collection)
    klass = resource.class
    klass = resource.unscoped.first.class if is_collection && resource.respond_to?(:unscoped)
    klass = resource[0].class if is_collection && resource.is_a?(Array)

    return "JsonApiSerializers::#{jsonapi_serializer}".constantize if jsonapi_serializer.present?

    "JsonApiSerializers::#{klass.name}Serializer".constantize
  end

end
