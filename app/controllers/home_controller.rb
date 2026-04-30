class HomeController < ApplicationController
  after_action :verify_policy_scoped, only: :index

  def index
    @pagy, @posts = pagy(
      policy_scope(Post).includes(:game, :author, :rich_text_body).order(published_at: :desc)
    )
  end
end
