class LikesController < ApplicationController
  ALLOWED_TYPES = %w[Post Comment].freeze

  before_action :authenticate_user!
  before_action :set_likeable

  def create
    @like = Like.find_or_create_by(user: current_user, likeable: @likeable)
    authorize @like
    redirect_back fallback_location: root_path
  end

  def destroy
    @like = Like.find_or_initialize_by(user: current_user, likeable: @likeable)
    authorize @like
    @like.destroy if @like.persisted?
    redirect_back fallback_location: root_path
  end

  private

  def set_likeable
    type = params[:likeable_type].to_s
    raise ActiveRecord::RecordNotFound unless ALLOWED_TYPES.include?(type)

    @likeable = type.constantize.find(params[:likeable_id])
  end
end
