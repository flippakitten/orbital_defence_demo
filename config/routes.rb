# frozen_string_literal: true
require 'sidekiq/web'
require_dependency 'sidekiq_auth'

Sidekiq::Web.set :session_secret, Rails.application.credentials.secret_key_base
Sidekiq::Web.set :sessions, Rails.application.config.session_options
Sidekiq::Web.class_eval do
  use Rack::Protection, origin_whitelist: ['https://orbitaldefence.tech'] # resolve Rack Protection HttpOrigin
end

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
          get '/search',  to: 'fires#search'
        end
      end
      resources :weather_readings, only: :show
    end
  end
end
