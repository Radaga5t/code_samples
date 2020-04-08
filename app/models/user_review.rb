# frozen_string_literal: true

# Модель отзыва пользователя
#
# == Валидации
# === +courtesy+, +punctuality+, +adequacy+
# Значение должно быть больше или равно 1 и меньше или равно 5
#
# === +review_type+
# Тип отзыва обязателен к заполнению
#
# == Колбеки
# === before_save set_review_positive
# устанавливает отметку "позитивный отзыв", если оценки +courtesy+,
# +punctuality+ и +adequacy+ больше 2
#
# === after_commit refresh_user_rating
# обновляет рейтинг пользователя в категории, связанной с заданием, к которому
# привязан этот отзыв
#
class UserReview < ApplicationRecord
  translates :text

  accepts_nested_attributes_for :translations, allow_destroy: true

  belongs_to :author,
             class_name: 'User',
             inverse_of: :user_reviews,
             optional: true

  belongs_to :user_rating, touch: true

  has_one :target_user,
          through: :user_rating,
          class_name: 'User',
          inverse_of: :reviews,
          source: :user

  belongs_to :task, inverse_of: :user_reviews, touch: true

  ## тип отзыва
  enum review_type: {
    author_as_contractor: 0,
    author_as_customer: 1
  }

  validates :courtesy, presence: true,
                       numericality: { greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: 5 }
  validates :punctuality, presence: true,
                          numericality: { greater_than_or_equal_to: 1,
                                          less_than_or_equal_to: 5 }
  validates :adequacy, presence: true,
                       numericality: { greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: 5 }

  validates :review_type, presence: true

  before_save :set_review_positive
  after_save :refresh_user_rating

  after_create_commit :increment_counter_cache
  after_destroy_commit :decrement_counter_cache

  ## подключаем бизнес логику работы с уведомлениями и начинаем прослушивать
  Notifications::Extensions::ForUserReview.instance.connect(self).listen

  def self.all_average(user_id)
    avg_res = ActiveRecord::Base.connection.exec_query(
      <<~SQL
        SELECT
        AVG(user_reviews.courtesy) as courtesy,
        AVG(user_reviews.punctuality) as punctuality,
        AVG(user_reviews.adequacy) as adequacy
        FROM user_reviews INNER JOIN user_ratings ON user_reviews.user_rating_id = user_ratings.id
        WHERE user_ratings.user_id = #{user_id}
      SQL
    )

    avg = avg_res.first

    avg.tap do |average|
      if average['courtesy'].present?
        average['total'] = (
          (average['courtesy'].to_f + average['punctuality'].to_f + average['adequacy'].to_f) / 3.0
        ).round(1)
        average['courtesy'] = average['courtesy'].to_f.round(1)
        average['punctuality'] = average['punctuality'].to_f.round(1)
        average['adequacy'] = average['adequacy'].to_f.round(1)
      else
        average['total'] = 0.0
        average['courtesy'] = 0.0
        average['punctuality'] = 0.0
        average['adequacy'] = 0.0
      end
    end
  end

  private

  def set_review_positive
    self.positive = (courtesy > 2 && punctuality > 2 && adequacy > 2)
  end

  def refresh_user_rating
    user_rating.refresh_for_review(self) if author_as_customer?
  end

  def increment_counter_cache
    user_rating.send(:increment_counter_cache, self)
  end

  def decrement_counter_cache
    user_rating.send(:decrement_counter_cache, self)
  end
end
