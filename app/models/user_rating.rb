# frozen_string_literal: true

# Модель рейтинга пользователя, рассчитывается исходя из
class UserRating < ApplicationRecord
  belongs_to :user, touch: true, inverse_of: :user_rating

  # имеет несколько рейтингов в категориях
  has_many :user_in_category_ratings, dependent: :destroy

  # имеет множество отзывов об этом пользователе
  has_many :user_reviews, dependent: :destroy

  # обновляет рейтинг всех пользователей
  def self.refresh_all
    all.map(&:create_and_refresh)
  end

  # обновляет рейтинг пользователя в категории для предоставленного отзыва
  # @param review [UserReview]
  def refresh_for_review(review)
    user_in_category_ratings
      .where(category_id: review.task.category_id)
      .first_or_create
      .refresh!
  end

  # обновляет рейтинг пользователя во всех категориях, в которых он выполнял
  # заказы
  def refresh
    user_in_category_ratings.each(&:refresh!)
  end

  # обновляет рейтинг пользователя абсолютно во всех активных категориях
  def create_and_refresh
    Category.active.select(:id).each do |category|
      user_in_category_ratings
        .where(category_id: category.id)
        .first_or_create
        .refresh!
    end
  end

  # возвращает рейтинг для указанной категории
  # @param category [Category, Integer]
  # @return [ActiveRecord::Relation<UserInCategoryRating>]
  def in_category(category)
    user_in_category_ratings
      .where(category_id: category.is_a?(Category) ? category.id : category)
  end

  private

  def increment_counter_cache(review)
    sql = 'UPDATE user_ratings
           SET reviews_counter = reviews_counter + 1'

    if review.positive?
      sql = "#{sql},
        positive_reviews_counter = positive_reviews_counter + 1"
    end

    sql = "#{sql} WHERE id = #{id}"

    ActiveRecord::Base.connection.exec_query(sql)
    user.touch
  end

  def decrement_counter_cache(review)
    sql = 'UPDATE user_ratings
           SET reviews_counter = reviews_counter - 1'

    if review.positive?
      sql = "#{sql},
         positive_reviews_counter = positive_reviews_counter - 1"
    end

    sql = "#{sql} WHERE id = #{id}"

    ActiveRecord::Base.connection.exec_query(sql)
    user.touch
  end
end
