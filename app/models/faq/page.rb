# frozen_string_literal: true

module Faq
  # FAQ page with content (detailed info) depends on category
  class Page < ApplicationRecord
    include PgSearch::Model
    include HasSlugCode

    translates :title, :content
    parameterize_column :title

    accepts_nested_attributes_for :translations, allow_destroy: true

    belongs_to :category,
               class_name: 'Faq::Category'

    pg_search_scope :search,
                    associated_against: {
                      translations: %i[title content]
                    },
                    using: {
                      tsearch: { prefix: true }
                    }

    def path
      [
        category_id.present? && category.parent_id.present? ? category.parent.slug : nil,
        category_id.present? ? category.slug : nil,
        slug
      ].compact.join('/')
    end
  end
end
