Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'videos#index'
  get '/my_queue', to: 'queue_items#index', as: 'my_queue'
  patch '/queue_items', to: 'queue_items#update', as: 'update_queue'

  get '/people', to: 'follows#index', as: 'people'

  resources :follows, only: [:destroy]
  resources :queue_items, only: [:destroy]
  resources :categories, only: [:show]
  resources :users, only: [:create, :show] do
    resources :follows, only: [:create]
  end
  resources :sessions, only: [:create]
  resources :videos, only: [:show] do
    collection { get 'search', to: 'videos#search' }
    resources :reviews, only: [:create]
    resources :queue_items, only: [:create]
  end
end
