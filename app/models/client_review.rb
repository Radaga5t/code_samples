# frozen_string_literal: true

# Static clients' reviews on main page managing
class ClientReview < ApplicationRecord
  include HasAssets

  translates :description, :text

  accepts_nested_attributes_for :translations, allow_destroy: true

  image_asset :photo,
              validate: {
                presence: true
              },
              versions: {
                large: [:resize_to_fill, 320, 320],
                small: [:resize_to_fill, 120, 120]
              }

  validates :photo, presence: true
end
