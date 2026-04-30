class FeedController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_policy_scoped, only: :index

  def index
    @pagy, @posts = pagy(
      policy_scope(Post)
        .where(game_id: current_user.subscribed_games.select(:id))
        .includes(:game, :author)
        .order(published_at: :desc)
    )
  end
end
