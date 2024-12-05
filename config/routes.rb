# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  resource :registration, only: %i[new create]
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'
  resource :top_up, only: %i[create]
  resources :transactions, only: %i[index]
  # resource :cart, only: [:show] do
  #   post 'add_item/:id', action: :add_item
  #   patch :update_item
  #   delete :remove_item
  # end
  resource :cart, only: :show do
    post 'add_item/:product_id', to: 'carts#add_item', as: 'add_item'
    delete 'remove_item/:item_id', to: 'carts#remove_item', as: 'remove_item'
  end
  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end
end
