class PostsController < ApplicationController
  def show
    @post = Post.friendly.find(params[:slug])
    authorize @post
    @pagy, @comments = pagy(@post.comments.includes(:user).recent)
  end
end
