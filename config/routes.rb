Rails.application.routes.draw do
  resources :tournaments do
    member do
      get 'add_editor'
      post 'create_editor'
    end
    delete 'remove_editor/:editor_id', to: 'tournaments#remove_editor', as: :remove_editor, on: :member, via: :delete
    resources :games do
      resources :teams do
        member do
          patch 'update_name'
        end
        resources :lineups
        resources :single_stats
      end
    end
    resources :rounds
    resources :teams do
      resources :players
      resources :favorites, only: [:new, :create, :destroy]
    end
    resources :standings
    resources :top_scorers
  end
  
  get '/last_tournaments', to: 'home#last_tournaments'
  get '/my_tournaments', to: 'home#my_tournaments'
  get '/favorites', to: 'home#favorites'
  
  
  root 'home#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
