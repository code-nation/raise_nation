Rails.application.routes.draw do
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
    resources :invite_user, only: [:create]
    resources :nations, only: [:new, :create] do
      get :connect, on: :member
      get :oauth, on: :collection
    end
    resources :raisely_campaigns, only: [:new, :create, :edit, :update]
  end
  namespace :settings do
    resources :update_current_account, only: [:update]
    resources :profile, only: [:edit, :update]
  end

  resources :accounts
  resources :workflows, only: [:index, :new, :create]
  namespace :workflows do
    resources :choices, only: [:index]
  end

  # Webhook endpoints
  post "webhooks/donation_given", to: "webhooks#donation_given"

  root 'dashboard#index'
end
