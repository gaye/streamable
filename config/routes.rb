Streamable::Application.routes.draw do
  root :to => 'home#index'

  match 'users/logout' => 'application#logout'
    
  resources :streams
  resources :subscriptions, :only => [:create, :destroy]
  resources :users, :only => [:show, :new]
  
  match 'auth/facebook/callback' => 'users#facebook_callback'
end
