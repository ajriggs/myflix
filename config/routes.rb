Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'videos#index'
  get '/categories/:id', to: 'categories#show', as: 'category'

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

end
