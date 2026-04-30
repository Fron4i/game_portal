ActiveAdmin.register Game do
  permit_params :title, :description, :released_at, :cover

  filter :title
  filter :released_at

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :released_at
    column :cover do |game|
      if game.cover.attached?
        image_tag url_for(game.cover), height: 60
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :released_at, as: :datepicker
      f.input :cover, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :released_at
      row :description
      row :cover do |game|
        if game.cover.attached?
          image_tag url_for(game.cover), height: 200
        end
      end
    end
  end
end
