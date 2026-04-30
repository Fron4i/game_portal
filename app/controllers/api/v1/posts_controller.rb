module Api
  module V1
    class PostsController < BaseController
      def index
        @pagy, @posts = pagy(
          Post.published.includes(:game, :author, :rich_text_body).order(published_at: :desc)
        )
        render json: ::PostSerializer.new(@posts, meta: pagy_meta(@pagy)).serializable_hash
      end

      def show
        @post = Post.includes(:game, :author, :rich_text_body, :comments, :likes).friendly.find(params[:slug])
        render json: ::PostSerializer.new(@post).serializable_hash
      end
    end
  end
end
