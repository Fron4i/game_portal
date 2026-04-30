class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    authorize @comment

    @comment.save
    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.friendly.find(params[:post_slug])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
