Rails.application.routes.draw do
  get 'account/destroy'
  delete 'account/remove_connection'
  get 'transactions/index'
  get "account/index"
  post "account/create_session"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root to: "home#index"
end
