# frozen_string_literal: true

module JsonApiSerializers
  # Сериализатор для ничего:)
  class NilClassSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower
  end
end
