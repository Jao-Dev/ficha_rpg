Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check
  root "users#index"

  resources :users, only: [ :index ] do
    resources :characters, only: [ :new, :create, :show, :edit, :update, :destroy ]
  end

  resources :campaigns, only: [ :show, :create, :edit, :update, :destroy ]
end
