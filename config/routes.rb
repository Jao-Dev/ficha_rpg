Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check
  root "users#index"

  resources :users, only: [ :index ] do
    resources :characters, only: [ :new, :create, :show, :edit, :update, :destroy ] do
      member do
        post :alternar
        post :adicionar_item
        patch :atualizar_item
        delete :remover_item
        post :adicionar_arma
        patch :atualizar_arma
        delete :remover_arma
        post :adicionar_efeito
        patch :atualizar_efeito
        delete :remover_efeito
      end
    end
  end

  resources :campaigns, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    resources :campaign_characters, only: [ :create, :update, :destroy ]
  end

  resources :avisos, only: [ :index ]
end
