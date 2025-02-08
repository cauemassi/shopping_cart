require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :products

  resource :cart, only: [:show, :create] do
    post 'add_items', on: :collection
    delete ':product_id', to: 'carts#delete_items', as: :delete_item
  end

  get "up", to: "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
