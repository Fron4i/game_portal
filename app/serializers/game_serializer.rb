class GameSerializer
  include JSONAPI::Serializer

  attributes :title, :slug, :description, :released_at

  attribute :cover_url do |game|
    if game.cover.attached?
      Rails.application.routes.url_helpers.rails_blob_path(game.cover, only_path: true)
    end
  end
end
