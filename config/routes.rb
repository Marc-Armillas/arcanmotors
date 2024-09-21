Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :cars, only: [:index, :show], defaults: { format: :html }

  # get 'admin22', to: 'admin#index'
  devise_scope :user do
    get '/admin22', to: 'users/sessions#new'
  end

  get 'admin', to: 'admin#index'
  get 'about_us', to: 'static_pages#about_us'
  get 'contact_us', to: 'static_pages#contact_us'
  root "static_pages#home"

  namespace :admin do
    resources :cars do
      member do
        delete "remove_image/:image_id", to: "cars#remove_image", as: "remove_image"
      end
    end
    resources :categories
    resources :category_types
  end

  # Default routes
  # To know the status of the app /up
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
