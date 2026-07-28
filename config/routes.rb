Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Categories and Subcategories
  resources :categories, only: [:index, :show] do
    member do
      get :subcategories
    end
  end
if Rails.env.production?
  post '/seed', to: 'seeds#run'
end
  resources :subcategories, only: [:index, :show]

  # Rest of your routes...
  resources :listings do
    collection do
      get :search
      get :jobs
      get :products
      get :for_sale
      get :for_rent
      get :wanted
    end
    member do
      post :favorite
      delete :unfavorite
      get :apply
      post :submit_application
      post :toggle_status
    end
    resources :job_applications, only: [:create]
  end

  resources :job_applications, only: [:show] do
    member do
      get :whatsapp
    end
  end

  resources :jobs, only: [:index, :show, :new, :create] do
    collection do
      get :listings
      get :seekers
    end
    member do
      get :seeker
    end
  end

  resources :cities, only: [:index, :show]
  resources :conversations, only: [:index, :show, :new, :create] do
    resources :messages, only: [:create]
  end
  resources :favorites, only: [:index, :create, :destroy]

  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/listings', to: 'dashboard#listings'
  get 'dashboard/jobs', to: 'dashboard#jobs'
  get 'dashboard/applications', to: 'dashboard#applications'
  get 'dashboard/messages', to: 'dashboard#messages'
  get 'dashboard/favorites', to: 'dashboard#favorites'
  get 'dashboard/settings', to: 'dashboard#settings'
  patch 'dashboard/update_settings', to: 'dashboard#update_settings'

  get 'search', to: 'listings#search'
  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
  post 'contact', to: 'home#send_contact'
  get 'terms', to: 'home#terms'
  get 'privacy', to: 'home#privacy'
  get 'how-it-works', to: 'home#how_it_works'

  get 'api/categories/:id/subcategories', to: 'api#category_subcategories'
end
