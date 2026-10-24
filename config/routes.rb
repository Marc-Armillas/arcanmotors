Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :cars, only: [ :index, :show ], defaults: { format: :html }, path: "coches"
  get "porsche-:slug-de-ocasion", to: "model_lines#show", as: :model_line, constraints: { slug: Regexp.union(ModelLine::SLUGS) }
  # get "admin22", to: "admin#index"
  devise_scope :user do
    get "/admin22", to: "users/sessions#new"
  end

  get "admin", to: "admin#index"
  get "about_us", to: "static_pages#about_us"
  get "contacto", to: "contact_requests#new", as: "contact_request"
  post "contacto", to: "contact_requests#create"
  get "avisame", to: "stock_alerts#new", as: :new_stock_alert
  post "avisame", to: "stock_alerts#create", as: :stock_alerts
  get "vende-tu-porsche", to: "sell_requests#new", as: :new_sell_request
  post "vende-tu-porsche", to: "sell_requests#create", as: :sell_requests
  get "privacidad", to: "static_pages#privacy", as: :privacy
  get "guias", to: "guides#index", as: :guides
  get "guias/:slug", to: "guides#show", as: :guide
  get "cookies_policy", to: "static_pages#cookies_policy"
  get "legal", to: "static_pages#legal"
  root "static_pages#home"

  namespace :admin do
    resources :cars do
      member do
        delete "remove_image/:image_id", to: "cars#remove_image", as: "remove_image"
      end
    end

    resources :contact_requests, only: [ :index, :update, :destroy ]
    resources :stock_alerts, only: [ :index, :update, :destroy ]
    resources :sell_requests, only: [ :index, :show, :update, :destroy ]
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
