# frozen_string_literal: true

module JsonApiSerializers
  module Faq
    # Frequently asked questions' serializer
    class PageSerializer
      include FastJsonapi::ObjectSerializer

      @not_simple_entity_cond = ->(_, params) { params[:simple].blank? || params[:simple] != true }

      set_key_transform :camel_lower

      attributes :title, :popular, :slug

      belongs_to :category

      attribute :content, if: @not_simple_entity_cond

      attribute :path
    end
  end
end
