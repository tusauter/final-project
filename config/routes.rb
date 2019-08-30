Rails.application.routes.draw do
  
  get "/", to: "users#index"
  get "/logout", to: "users#logout"

  ###############
  # User routes #
  ###############

  post "/login", to: "users#login_user"
  get "/sign_up", to: "users#registration_form"
  get "/forgot", to: "users#forgot_form"
  # get "/password_reset_email"

  # CREATE
  post "/post_user", to: "users#create"

  # READ
  get "/users", to: "users#index"
  get "/users/:user_id", to: "users#show"
  get "/sign_in", to: "users#login_form"
  get "/users/:user_id/activate=:activation_token", to: "users#activation_screen"

  # UPDATE
  get "/regenerate_activation/:user_id/:activation_token", to: "users#regenerate_activation"

  # DESTROY


  ####################
  # Apartment Routes #
  ####################

  # CREATE
  post "/add_apartment", to: "apartments#create"

  # READ

  # UPDATE

  # DESTROY

  # ==============
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
