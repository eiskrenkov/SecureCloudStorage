Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :uploads
  resources :generate_keys, only: :index

  root to: 'pages#home'
end
