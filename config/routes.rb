Streamable::Application.routes.draw do
  root :to => 'home#index'
  
  resources :streams
  resources :subscriptions, :only => [:create, :destroy]
  resources :users, :only => [:show, :new]
  
  match 'auth/facebook/callback' => 'users#facebook_callback'
  match 'users/logout' => 'users#logout'
end
