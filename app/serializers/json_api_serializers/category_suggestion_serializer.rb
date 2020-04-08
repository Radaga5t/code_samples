# frozen_string_literal: true

module JsonApiSerializers
  # Сериализатор для категорий
  class CategorySuggestionSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower
    attributes :text, :category, :parent_id, :cat_id
  end
end
