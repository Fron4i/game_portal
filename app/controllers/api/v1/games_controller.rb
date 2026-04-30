module Api
  module V1
    class GamesController < BaseController
      def index
        @pagy, @games = pagy(Game.with_attached_cover.latest)
        render json: GameSerializer.new(@games, meta: pagy_meta(@pagy)).serializable_hash
      end

      def show
        @game = Game.with_attached_cover.friendly.find(params[:slug])
        render json: GameSerializer.new(@game).serializable_hash
      end
    end
  end
end
