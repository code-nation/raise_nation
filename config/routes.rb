Rails.application.routes.draw do
  resources :blas
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :sb_admin_docs, only: :index do
    get :buttons, :cards, :utilities_color, :utilities_border,
        :utilities_animation, :utilities_other, :login, :register,
        :forgot_password, :page_404, :blank, :charts, :tables,
        on: :collection
  end
  resources :dashboard
  namespace :accounts do
    resources :toggle_notification, only: [:update]
  end
  namespace :settings do
    resources :update_current_account, only: [:update]
    resources :profile, only: [:index, :create]
  end

  resources :accounts

  root 'dashboard#index'
end
