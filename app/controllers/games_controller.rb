class GamesController < ApplicationController
  after_action :verify_policy_scoped, only: :index

  def index
    @pagy, @games = pagy(policy_scope(Game).latest)
  end

  def show
    @game = Game.friendly.find(params[:slug])
    authorize @game
    @pagy, @posts = pagy(@game.posts.published.includes(:author, :rich_text_body).order(published_at: :desc))
  end
end
