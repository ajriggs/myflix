Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'videos#index'

  resources :categories, only: [:show]
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :videos, only: [:show] do
    collection { get 'search', to: 'videos#search' }
    resources :reviews, only: [:create]
  end
end
