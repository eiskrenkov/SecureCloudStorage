Rails.application.routes.draw do
  devise_for :users

  resources :uploads, only: %i[create show destroy] do
    get :show_image, on: :member
  end

  root to: 'pages#home'
end
