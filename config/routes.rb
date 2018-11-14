# frozen_string_literal: true

require_dependency 'sidekiq_auth'

Rails.application.routes.draw do
  constraints ->(request) { SidekiqAuth.admin?(request) } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  root to: "pages#root"

  resources :fires, only: :index
end
