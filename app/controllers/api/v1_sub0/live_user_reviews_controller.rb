# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса live_user_reviews
    class LiveUserReviewsController < ApiController
      def index
        json_response scope
      end

      private

      def scope
        UserReview
          .includes(:translations, :author, :task, task: [:translations])
          .where('user_reviews.review_type': :author_as_customer)
          .order('user_reviews.created_at': :desc)
          .limit(5)
      end
    end
  end
end
