Myflix::Application.routes.draw do
  get '/home', to: 'categories#index'
  get '/videos/:id', to: 'videos#show', as: 'video'
  get '/categories/:id', to: 'categories#show', as: 'category'

  get 'ui(/:action)', controller: 'ui'

end
