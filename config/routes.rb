Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'

  get '/register', to: 'users#new'
  resources :users, only: [:create, :show] do
    resources :follows, only: [:create]
  end

  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  get 'forgot_password', to: 'forgot_passwords#new', as: 'forgot_password'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password/email_confirmed', to: 'forgot_passwords#email_confirmed', as: 'email_confirmed'

  get 'reset_password/:token', to: 'reset_passwords#edit', as: 'reset_password'
  get 'invalid_token', to: 'reset_passwords#invalid_token', as: 'invalid_token'
  patch 'reset_password/:token', to: 'reset_passwords#update', as: 'update_password'

  resources :categories, only: [:show]

  get 'home', to: 'videos#index', as: 'home'
  resources :videos, only: [:show] do
    collection { get 'search', to: 'videos#search' }
    resources :reviews, only: [:create]
    resources :queue_items, only: [:create]
  end

  get 'my_queue', to: 'queue_items#index', as: 'my_queue'
  patch 'queue_items', to: 'queue_items#update', as: 'update_queue'
  resources :queue_items, only: [:destroy]

  get 'people', to: 'follows#index', as: 'people'
  resources :follows, only: [:destroy]

  resources :invitations, only: [:new, :create]
end
