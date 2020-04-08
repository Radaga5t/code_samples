# frozen_string_literal: true

module JsonApiSerializers
  module Seo
    # Сериализатор для городов пользователей. Для приложения СЕО.
    class CitySerializer
      include FastJsonapi::ObjectSerializer

      set_key_transform :camel_lower

      attribute :name, :slug, :lat, :lng, :city_grammar
    end
  end
end
