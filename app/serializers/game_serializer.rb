class GameSerializer
  include JSONAPI::Serializer

  attributes :title, :slug, :description, :released_at

  attribute :cover_url do |game|
    Rails.application.routes.url_helpers.url_for(game.cover) if game.cover.attached?
  end
end
