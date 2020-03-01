Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  devise_scope :user do
    get '/signup', to: 'users/registrations#new'
    get '/login', to: 'users/sessions#new'
    post '/login', to: 'users/sessions#create'
    delete '/logout', to: 'users/sessions#destroy'
  end
  resources :users, only: [:show, :index] do
    member do
      get 'password_edit', to: 'users#password_edit'
      patch 'password_update', to: 'users#password_update'
      get 'like', to: 'users#like'
    end
  end
  resources :trips
  resources :likes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
