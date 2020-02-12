Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about' 
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  devise_scope :user do
    get '/signup', to: 'users/registrations#new'
    get '/login', to: 'users/sessions#new'
    post '/login', to: 'users/sessions#create'
    delete '/logout', to: 'users/sessions#destroy'
  end
end
