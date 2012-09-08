Icnow2::Application.routes.draw do
  resources :events, :deals

  resources :movies, :only => [:index, :show]

  resources :users
  resources :user_sessions, :only => [:new, :create, :destroy]

  resources :arrests, :only => [:index, :show]

  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'

  root :to => 'home#index'
end
