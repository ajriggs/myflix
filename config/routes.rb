Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/register', to: 'users#register', as: 'register'
  get '/login', to: 'sessions#login', as: 'login'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/home', to: 'videos#index', as: 'home'
  get '/categories/:id', to: 'categories#show', as: 'category'

  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

end
