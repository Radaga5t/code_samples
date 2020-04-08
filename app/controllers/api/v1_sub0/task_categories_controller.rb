# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса task/:taskId/categories
    class TaskCategoriesController < ApiController
      def show
        cat = Task.find(params[:task_id]).category
        authorize cat
        json_response cat
      end
    end
  end
end
