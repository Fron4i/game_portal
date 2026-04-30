require "sidekiq/web"

Sidekiq::Web.use Rack::Auth::Basic do |user, password|
  ActiveSupport::SecurityUtils.secure_compare(user, ENV.fetch("SIDEKIQ_USER")) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch("SIDEKIQ_PASSWORD"))
end

Rails.application.routes.draw do
  mount Sidekiq::Web => "/admin/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.development?
    get "/styleguide", to: "styleguide#show"
  end
end
