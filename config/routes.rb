require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.development?
    get "/styleguide", to: "styleguide#show"
  end
end
