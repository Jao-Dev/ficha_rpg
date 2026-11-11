Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  get "up" => "rails/health#show", as: :rails_health_check
  root "characters#index"

  resources :users do
    resources :characters, only: [ :show, :create, :update, :destroy ]
  end

  resources :campaigns, only: [ :show, :create ]
end
