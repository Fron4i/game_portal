require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  root "home#index"

  resources :games, only: [:index, :show], param: :slug do
    post "subscriptions", to: "subscriptions#create", on: :member, as: :subscriptions
    delete "subscriptions", to: "subscriptions#destroy", on: :member
  end

  resources :posts, only: [:show], param: :slug do
    resources :comments, only: [:create, :destroy]
  end

  post "/likes", to: "likes#create"
  delete "/likes", to: "likes#destroy"

  get "/feed", to: "feed#index", as: :feed

  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.development?
    get "/styleguide", to: "styleguide#show"
  end
end
