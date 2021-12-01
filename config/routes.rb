Rails.application.routes.draw do
  get "account/index"
  post "account/create_session"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: "home#index"
end
