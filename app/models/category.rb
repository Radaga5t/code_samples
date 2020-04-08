# frozen_string_literal: true

# Модель Категория заданий
class Category < ApplicationRecord
  include HasAssets
  include HasSlugCode
  include PgSearch::Model

  translates :name, :description, :title
  globalize_accessors locales: I18n.available_locales,
                      attributes: %i[name description title]

  parameterize_column :name
  accepts_nested_attributes_for :translations, allow_destroy: true

  pg_search_scope :search,
                  associated_against: {
                    translations: %i[name]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  has_and_belongs_to_many :task_templates
  has_many :seo_categories,
           class_name: 'Seo::Category',
           dependent: :destroy

  has_many :children,
           class_name: 'Category',
           foreign_key: 'parent_id',
           dependent: :destroy,
           inverse_of: :parent

  has_many :tasks,
           class_name: 'Task',
           dependent: :nullify,
           inverse_of: :category

  belongs_to :parent,
             class_name: 'Category',
             optional: true,
             inverse_of: :children

  has_many :user_favorite_categories, dependent: :destroy
  has_many :users, through: :user_favorite_categories

  has_many :category_suggestions, dependent: :destroy

  image_asset :icon
  image_asset :ad_banner

  # depth_level в зависимости от parent.depth_level
  before_save :set_depth_level, on: %i[create update]

  default_scope -> { order(sort: :asc, id: :asc) }

  # Активные/неактивные категории
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # корневые категории
  scope :root, -> { where(depth_level: 0) }

  Notifications::Extensions::ForCategory.instance.connect(self)

  # instance methods

  def task_templates
    return TaskTemplate.joins(:categories).where('categories.id': [id, parent_id]) if parent_id.present?

    super
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

  def cache_version
    updated_at.utc.to_s(:usec)
  end

  private

  def set_depth_level
    self.depth_level = parent.depth_level + 1 if parent
  end
end
