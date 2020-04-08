# frozen_string_literal: true

# Модель шаблона форм для заданий в категориях
class TaskTemplate < ApplicationRecord
  include HasAssets

  before_validation :parse_template_file #, if: :template_file_changed?
  before_save :rewrite_template_file

  # @!attribute categories
  # может быть привязан к нескольким категориям, в случае, когда разные
  # категории имеют одинаковую структуру заданий
  # @return [ActiveRecord::Associations::CollectionProxy]
  has_and_belongs_to_many :categories

  # @!attribute template
  # Шаблон создаваемых в этой категории заданий,
  # @return [TaskTemplates::FormRoot]
  attribute :template,
            TaskTemplates::FormRoot.to_type,
            default: TaskTemplates::FormRoot.new

  file_asset :template_file

  validates :template, presence: true,
                       store_model: {
                         merge_errors: true
                       }

  enum position: %i[before_text after_text after_date additional]

  default_scope -> { order(sort: :asc, position: :asc) }

  def as_json
    super.tap do |task_template|
      task_template['template'] = template.elements_as_template_json
    end
  end

  private

  def parse_template_file
    return if template_file.blank? || template_file.file.blank?

    file = File.open(template_file.file.path, 'r+')
    data_hash = JSON.parse(file.read)
    self.template = data_hash
  end

  def rewrite_template_file
    return if template_file.blank? || template_file.file.blank?

    File.open(template_file.file.path, 'w') { |file| file.write template.to_json }
  end
end
