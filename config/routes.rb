Rails.application.routes.draw do
  get "account/index"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: "home#index"
end
