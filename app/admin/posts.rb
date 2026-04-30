ActiveAdmin.register Post do
  permit_params :title, :kind, :published_at, :game_id, :author_id, :body

  filter :kind, as: :select, collection: -> { Post.kinds }
  filter :game
  filter :published_at

  index do
    selectable_column
    id_column
    column :title
    column :kind
    column :game
    column :author
    column :published_at
    actions do |post|
      unless post.published?
        item "Опубликовать", publish_admin_post_path(post), method: :put, class: "member_link"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :kind, as: :select, collection: Post.kinds.keys
      f.input :game
      f.input :author, collection: User.order(:email)
      f.input :published_at, as: :datepicker
      f.input :body, as: :rich_text_area
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :kind
      row :game
      row :author
      row :published_at
      row :body do |post|
        post.body.to_s.html_safe
      end
    end
  end

  member_action :publish, method: :put do
    resource.update(published_at: Time.current)
    redirect_to admin_post_path(resource), notice: "Пост опубликован."
  end

  controller do
    def new
      super
      @post.author ||= current_user
    end
  end
end
