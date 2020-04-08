require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'

  root 'main#index'
  devise_for :users

  namespace :blog do
    root 'articles#index'
    resources :articles, param: :slug
    get '/articles/:slug/crop', to: 'articles#crop'
  end

  authenticate :user, lambda { |u| u.administrator? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :payments do
    namespace :barion do
      post 'refill', to: 'barion#refill'
    end
    namespace :simple_pay do
      post 'ipn', to: 'simple_pay#ipn'
      post 'back', to: 'simple_pay#back'
    end
  end

  namespace :api do
    scope '(/:locale)', locale: /#{I18n.available_locales.join('|')}/ do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        confirmations: 'api/netlab_devise/confirmations',
        registrations: 'api/netlab_devise/registrations',
        sessions: 'api/netlab_devise/sessions',
        omniauth_callbacks: 'api/netlab_devise/omniauth_callbacks',
        passwords: 'api/netlab_devise/passwords',
        token_validations: 'api/netlab_devise/token_validations'
      }
    end

    api_version(
      module: "V1Sub0",
      path: {value: "v1.0"},
      defaults: {format: :json}) do

      root 'api#index', as: :root

      scope '(/:locale)', locale: /#{I18n.available_locales.join('|')}/ do
        resources :categories, only: [:index, :show]
        resources :category_suggestions, only: [:index]
        resources :languages, only: [:index]
        resources :user_roles, only: [:index]
        resources :subscription_services, only: [:index]
        resources :single_offer_services, only: [:index]
        resources :promocodes, only: [:index]
        resources :executors, only: [:index]
        resources :client_reviews, only: [:index]
        resources :promo_articles, only: [:index]
        resources :live_user_reviews, only: [:index]

        # Задания
        resources :tasks do
          resource :category, controller: :task_categories, only: [:show]
          resources :task_photos
          resources :task_responses
        end

        # временные файлы для ресурсов, которые находятся на стадии создания, но еще не существуют в базе
        scope '/temp_files/:for_resource' do
          resources :files, controller: :temp_files
        end

        # Пользователь сервиса
        resource :user do
          resource :user_photo, only: [:show, :update]
          resource :user_verification, only: [:show, :update]
          resource :user_view_statistic, only: [:show]
          resource :user_account, only: [:show] do
            post :refill
          end
          resource :user_subscription, only: [:show, :create]
          resources :user_account_transactions, only: [:index]
          resources :user_roles, only: [:index]
          resources :user_favorite_categories, only: [:index, :update]
          resources :user_portfolios
          resources :tasks, controller: :user_tasks
          resources :task_responses, controller: :user_task_responses
          resources :user_reviews, only: [:index], controller: :user_reviews

          ## custom actions
          get :ready_to_offer_tasks, controller: :user_tasks, action: :ready_to_offer
          post :new_task_offer, controller: :user_tasks, action: :new_task_offer
          post :track_new_user_registration, controller: :users, action: :track_new_user_registration
        end
        resource :user_configuration, only: [:update]

        # Пользователи сервиса
        resources :users do
          resource :user_photo, only: [:show]
          resource :user_verification, only: [:show]
          resource :user_view_statistic, only: [:show]
          resources :user_portfolios, only: [:index, :show]
          resources :user_favorite_categories, only: [:index, :show]
          resources :tasks, only: [:index], controller: :user_tasks
          resources :user_reviews, only: [:index], controller: :user_reviews
        end

        namespace :faq do
          resources :categories, only: [:index]
          resources :pages, only: %i[index show]
        end

        namespace :chat do
          resources :groups, only: [:index]

          # кастомные не rest экшны
          post :new_chat, controller: :actions
        end

        namespace :seo do
          resources :executors, param: :slug, only: %i[index show]
          resources :categories, only: %i[index show]
          resources :cities, param: :slug, only: %i[index show]
          resource :main_page, only: %i[show]
        end
      end

      namespace :admin do
        namespace :blog do
          resources :articles
        end
      end
    end

    # Api сервисов геолокации
    scope '(/:locale)', locale: /#{I18n.available_locales.join('|')}/ do
      get 'place_autocomplete', controller: :google_maps
      get 'place_details', controller: :google_maps
      get 'place_by_coords', controller: :google_maps
      get 'place_by_request_ip', controller: :google_maps
    end
  end
end
