Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about' 
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
