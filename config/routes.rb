# frozen_string_literal: true

require_dependency 'sidekiq_auth'

Rails.application.routes.draw do
  constraints ->(request) { SidekiqAuth.admin?(request) } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  root to: "pages#root"

  namespace :api do
    namespace :v1 do
      resources :fires, only: :index do
        collection do
          get '/windIndicators', to: 'fires#fires_current_wind_direction_indicator'
        end
      end
      resources :weather_readings, only: :show
    end
  end
end
