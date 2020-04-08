# frozen_string_literal: true

# Временные файлы, которые хранятся до создания какой-нибудь сущности
class TempFile < ApplicationRecord
  include HasAssets

  belongs_to :user, optional: true

  file_assets :files
end
