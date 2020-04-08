# frozen_string_literal: true

# модуль с бизнес логикой работы с символьным кодом записи
# параметризует указанный с помощью +parameterize_column+ аттрибут в +slug+
module HasSlugCode
  extend ActiveSupport::Concern

  included do
    # after_initialize :generate_slug
    before_validation :generate_slug

    # Slug начинается с буквы или цифры и содержит только
    # буквы/цифры/тире(-)/подвал(_)
    validates :slug,
              presence: true,
              format: {
                with: /\A[a-z0-9][a-z0-9\-_]+\z/,
                message: 'Only allows letters and digits'
              }

    protected

    def generate_slug
      return unless need_to_generate_slug?

      column = send(self.class.parameterize_column_to_slug)
      self[:slug] = column.parameterize
    end

    private

    def need_to_generate_slug?
      respond_to?(:slug) &&
        slug.blank? &&
        self.class.parameterize_column_to_slug.present? &&
        respond_to?(self.class.parameterize_column_to_slug) &&
        self[self.class.parameterize_column_to_slug].present?
    end
  end

  class_methods do
    attr_reader :parameterize_column_to_slug

    def parameterize_column(column_name)
      @parameterize_column_to_slug = column_name
    end
  end
end
