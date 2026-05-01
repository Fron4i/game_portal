Rails.application.config.active_storage.content_types_to_serve_as_binary -= %w[image/svg+xml]
Rails.application.config.active_storage.content_types_allowed_inline    += %w[image/svg+xml]
