class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize :profile, :show?
    @pagy, @comments = pagy(
      current_user.comments.includes(:post).order(created_at: :desc),
      limit: 20
    )
    @subscribed_games = current_user.subscribed_games.includes(cover_attachment: :blob)
  end
end
