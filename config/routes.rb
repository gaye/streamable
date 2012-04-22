Streamable::Application.routes.draw do
  root :to => 'home#index'
  
  resources :streams
  resources :subscriptions, :only => [:create, :destroy]
  
  match 'users/logout' => 'application#logout'
  resources :users, :only => [:show, :new]
  
  match 'auth/facebook/callback' => 'users#facebook_callback'
end
