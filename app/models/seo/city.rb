# frozen_string_literal: true

module Seo
  # Города в СЕО-приложении
  class City < ApplicationRecord
    include HasSlugCode
    include HasAssets

    parameterize_column :name
  end
end
