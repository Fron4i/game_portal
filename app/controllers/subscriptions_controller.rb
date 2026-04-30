class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game

  def create
    @subscription = Subscription.find_or_create_by(user: current_user, game: @game)
    authorize @subscription
    redirect_to game_path(@game), notice: t("iwebix.flash.notice")
  end

  def destroy
    @subscription = Subscription.find_or_initialize_by(user: current_user, game: @game)
    authorize @subscription
    @subscription.destroy if @subscription.persisted?
    redirect_to game_path(@game), notice: t("iwebix.flash.notice")
  end

  private

  def set_game
    @game = Game.friendly.find(params[:slug])
  end
end
