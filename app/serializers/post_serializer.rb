class PostSerializer
  include JSONAPI::Serializer

  attributes :title, :slug, :kind, :published_at

  attribute :body_html do |post|
    post.body.to_s
  end

  attribute :likes_count do |post|
    post.likes.size
  end

  attribute :comments do |post|
    post.comments.includes(:user).order(created_at: :desc).map do |c|
      { id: c.id, body: c.body, user_name: c.user&.name, created_at: c.created_at }
    end
  end
end
