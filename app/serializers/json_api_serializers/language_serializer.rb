# frozen_string_literal: true

module JsonApiSerializers
  # Сериализатор для категорий
  class LanguageSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower
    attributes :name, :code, :native_name
  end
end
