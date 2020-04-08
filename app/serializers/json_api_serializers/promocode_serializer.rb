# frozen_string_literal: true

module JsonApiSerializers
  # сериалайзер для промокода
  class PromocodeSerializer
    include FastJsonapi::ObjectSerializer
    include Helpers::Money

    set_key_transform :camel_lower

    attribute :amount do |object|
      money(object) if object.absolute?
    end

    attribute :relative_amount do |object|
      object.relative_amount if object.relative?
    end

    attribute :active, &:active?

    attributes :type_of_discount, :label, :description
  end
end
