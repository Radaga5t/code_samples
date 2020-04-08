# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса tasks/:taskId/task_responses
    class TaskResponsesController < ApiController
      before_action :authenticate_user!, only: %i[create update destroy]
      after_action :verify_authorized

      def index
        task_responses = collection
        authorize(task_responses)
        jsonapi_filter(
          task_responses,
          %i[status user_profile_rating published_at]
        ) do |filtered|
          json_response(
            jsonapi_paginate(filtered.result)
          )
        end
      end

      def create
        authorize(TaskResponse)
        existed_task_response = current_user.task_responses.where(task_id: params[:task_id]).first
        task_response = if existed_task_response.present?
                          existed_task_response.update(task_response_params)
                        else
                          current_user.task_responses.create(task_response_params) do |tr|
                            tr.task_id = params[:task_id]
                          end
                        end
        publish_if_needed(task_response)
        json_response(task_response)
      end

      def show
        task_response = TaskResponse.find(params[:id])
        authorize(task_response)
        json_response(task_response)
      end

      def update
        task_response = TaskResponse.find(params[:id])
        authorize(task_response)

        task_response.update(task_response_params)

        publish_if_needed(task_response)
        republish_if_needed(task_response)
        select_if_needed(task_response)
        abort_if_needed(task_response)

        json_response(task_response)
      end

      def destroy
        task_response = TaskResponse.find(params[:id])
        authorize(task_response)
        if task_response.deleted? || task_response.draft?
          task_response.destroy
        else
          task_response.delete
        end
        json_response(task_response)
      end

      private

      def jsonapi_serializer_params
        super.merge(simple: true) if action_name == 'index'
        super
      end

      def collection
        @_task = Task.find(params[:task_id])
        scope = @_task.task_responses
                  .includes(:translations,
                            :user,
                            user: [:user_account, :user_roles, :translations, user_account: [:user_services]])
                  .where.not(filtered_by_moderator: true)

        if current_user.present? && @_task.user_id == current_user.id
          statuses = \
            if @_task.published?
              [TaskResponse.statuses['published'],
               TaskResponse.statuses['selected'],
               TaskResponse.statuses['expired']]
            else
              [TaskResponse.statuses['selected']]
            end

          return scope.where('status in (?)', statuses)
        end

        return scope.where(user_id: current_user.id) if current_user.present?

        scope.published
      end

      def task_response_params
        attrs_whitelist = %i[
          description budget relevance_time notify_me_if_other_selected
        ]

        jsonapi_deserialize(params, only: attrs_whitelist)
      end

      def publish_if_needed(task_response)
        action_meta = jsonapi_action_meta
        return unless task_response&.valid? && action_meta&.dig(:action_name) == 'publish'

        self.jsonapi_response_meta = {}
        transaction = task_response.submit

        return unless transaction.is_a?(AccountTransactions::ServiceActivationTransaction)

        self.jsonapi_response_meta = {}
        transaction.process
        return unless transaction.rejected?

        task_response.user_service.destroy if task_response.user_service.present?
        jsonapi_response_meta[:error] = {
          status: '422',
          title: 'not_enough_amount',
          not_enough_amount: (transaction.amount - current_user.user_account.amount).amount.to_f,
          price: transaction.amount.amount.to_f,
          account_amount: current_user.user_account.amount.amount.to_f,
          currency: transaction.amount.currency
        }

        ## Пока мы удаляем все черновики, если они не были сразу опубликованы
        task_response.destroy
      end

      def republish_if_needed(task_response)
        action_meta = jsonapi_action_meta
        return unless task_response&.valid? && action_meta&.dig(:action_name) == 'republish'

        self.jsonapi_response_meta = {}

        task_response.user_service.destroy if task_response.user_service.present?
        task_response.update_column(:status, 0)
        task_response.reload

        transaction = task_response.submit

        return unless transaction.is_a?(AccountTransactions::ServiceActivationTransaction)

        self.jsonapi_response_meta = {}
        transaction.process
        return unless transaction.rejected?

        task_response.user_service.destroy if task_response.user_service.present?
        jsonapi_response_meta[:error] = {
          status: '422',
          title: 'not_enough_amount',
          not_enough_amount: (transaction.amount - current_user.user_account.amount).amount.to_f,
          price: transaction.amount.amount.to_f,
          account_amount: current_user.user_account.amount.amount.to_f,
          currency: transaction.amount.currency
        }

        ## Пока мы удаляем все черновики, если они не были сразу опубликованы
        task_response.destroy
      end

      def select_if_needed(task_response)
        action_meta = jsonapi_action_meta
        return unless task_response&.valid? && action_meta&.dig(:action_name) == 'select'
        return if task_response.task.user_id != current_user.id

        task_response.select
        task_response.task.reload
      end

      def abort_if_needed(task_response)
        action_meta = jsonapi_action_meta

        return if task_response.blank?
        return unless task_response.valid? && action_meta&.dig(:action_name) == 'abort_task_response'

        action_attributes = action_meta&.dig(:attributes)

        if action_attributes[0].present? && task_response.respond_to?(:reason_text)
          task_response.reason_text = action_attributes[0]
        end

        task_response.abort
      end
    end
  end
end
