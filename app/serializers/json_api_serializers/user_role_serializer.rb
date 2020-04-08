# frozen_string_literal: true

module JsonApiSerializers
  # сериалайзер для ролей пользователя
  class UserRoleSerializer
    include FastJsonapi::ObjectSerializer

    cache_options enabled: true, cache_length: 20.minutes
    set_key_transform :camel_lower
    attributes :id, :name, :slug

    link :self, -> (object) {
      "/api/v1.0/user_role/#{object.id}"
    }
  end
end
