Rails.application.routes.draw do
  resources :tournaments do
    collection do 
      get 'favorites'
      get 'last_tournaments'
    end
    resources :games do
      resources :teams do
        resources :lineups
        resources :single_stats
      end
    end
    resources :rounds
    resources :teams do
      resources :players
    end
    resources :standings
    resources :top_scorers
  end
  resources :favorite_teams_users, only: [] do
    post 'toggle_favorite', on: :collection
  end
  
  
  root 'home#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
