Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :finances do
      resources :transactions, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
