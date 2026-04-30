ActiveAdmin.register Comment do
  permit_params :body

  actions :index, :show, :destroy

  filter :user
  filter :post
  filter :created_at

  index do
    selectable_column
    id_column
    column :user
    column :post
    column :body
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :post
      row :body
      row :created_at
    end
  end
end
