Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check
  root "users#index"

  resources :users, only: [ :index ] do
    resources :characters, only: [ :new, :create, :show, :edit, :update, :destroy ] do
      member { post :alternar }
    end
  end

  resources :campaigns, only: [ :index, :show, :create, :edit, :update, :destroy ] do
    resources :campaign_characters, only: [ :create, :update, :destroy ]
  end

  resources :avisos, only: [ :index ]
end
