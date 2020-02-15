# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/show'
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

  resources :users, only: [:show]
  resources :trips
end
