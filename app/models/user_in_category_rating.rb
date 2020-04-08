# frozen_string_literal: true

##
# Модель рейтинга пользователя в категории
# == Формула расчета
# === Коэффициенты участвующие в расчете рейтинга исполнителей:
# - Оценка исполнителя (В) — средний балл за 5 последних заданий разделить на
#   максимальный балл — 5. В результате получается цифра <=1;
# - Давность выполнения задания (Т) — количество дней в периоде от даты
#   выполнения последнего задания по настоящее время, разделенное на 100.
#   Результат может быть как меньше, так и больше 1. Если исполнитель не
#   выполнял задание более 100 дней, то коэффициент будет больше 1.
# - Степень скудности профиля (П) — количество незаполненных полей, разделенное
#   на количество всех полей в профиле, включая привязку к социальным сетям.
#   В результате получаем число в интервале [0, 1], где 0 - абсолютно полный
#   профиль, 1 - абсолютно пустой
# - Качество отзывов (О) — количество плохих отзывов (D) из последних 100
#   отзывов и деленное на 10. Таким образом если исполнитель получил 10
#   плохих отзывов коэффициент будет равен 1. Чтобы это исправить он должен
#   будет выполнить около 100 заданий с положительной отметкой.
#
# === Формула расчета рейтинга (Р):
# <tt>Р = (В - Т - П - О).</tt>
#
# Рейтинг может быть как положительный, так и отрицательный, но не более 1.
#
class UserInCategoryRating < ApplicationRecord
  belongs_to :category
  belongs_to :user_rating, touch: true

  has_many :user_reviews, through: :user_rating, class_name: 'UserReview'

  # Обновляет рейтинг пользователя для категории, к которой привязан текущий
  # элемент
  # @return [Float]
  def refresh
    self.rating = calculate
  end

  # Обновляет рейтинг пользователя для категории, к которой привязан текущий
  # элемент и сохраняет значение
  # @return [Float]
  def refresh!
    self.rating = calculate
    save!
  end

  # Возвращает все отзывы о пользователе к заданиями в категории, к которой
  # принадлежит этот рейтинг, учитываются только отзывы, оставленные заказчиками
  # @return [ActiveRecord::Relation<UserReview>]
  def reviews_in_category
    if category.depth_level > 0
      user_reviews.joins(:task)
        .where('tasks.category_id': category.id,
               'user_reviews.review_type': :author_as_customer)
    else
      reviews_in_child_categories
    end
  end

  # Возвращает все отзывы о пользователе к заданиями в дочерних категориях, к которой
  # принадлежит этот рейтинг, учитываются только отзывы, оставленные заказчиками
  # @return [ActiveRecord::Relation<UserReview>]
  def reviews_in_child_categories
    user_reviews.joins(:task)
      .where('tasks.category_id': [category.id] + category.children.select(:id).pluck(:id).uniq,
             'user_reviews.review_type': :author_as_customer)
  end

  # Возвращает последний отзыв к заданию в категории, к которой принадлежит
  # этот рейтинг
  # @return [ActiveRecord::Relation<UserReview>]
  def latest_review
    reviews_in_category.order('tasks.closed_at': :desc).limit(1)
  end

  private

  def calculate
    if reviews_in_category.exists?
      calculate_for_experienced
    else
      calculate_for_newbie
    end
  end

  def calculate_for_newbie
    0.0 - account_age_days / 100.0 - profile_poverty
  end

  def calculate_for_experienced
    average_point / 5.0 - days_have_passed / 100.0 - profile_poverty -
      negative_reviews_count / 10.0
  end

  def average_point
    points.reduce(0) do |average, point|
      average + point.sum / 3.0
    end / points.size
  end

  def points
    reviews_in_category.pluck(:courtesy, :punctuality, :adequacy)
  end

  def days_have_passed
    (Time.current - latest_review.pluck(:created_at).first) / 86_400.0
  end

  def profile_poverty
    1 - user_rating.user.profile_richness
  end

  def negative_reviews_count(limit = 100)
    reviews_in_category
      .limit(limit)
      .where('user_reviews.positive = ?', false)
      .size
  end

  def account_age_days
    (Time.current - user_rating.user.created_at) / 86_400.0
  end
end
