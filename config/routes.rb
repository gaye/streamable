Streamable::Application.routes.draw do
  root :to => 'home#index'
  
  resources :streams
  resources :subscriptions
  resources :users
end
