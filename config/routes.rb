Myflix::Application.routes.draw do
  get '/home', to: 'videos#index', as: 'home'
  get '/:id', to: 'videos#show', as: 'video'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  get '/categories/:id', to: 'categories#show', as: 'category'

  get 'ui(/:action)', controller: 'ui'

end
