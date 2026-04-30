ActiveAdmin.register User do
  permit_params :name, :email, :role, :blocked, :password, :password_confirmation

  filter :role, as: :select, collection: -> { User.roles }
  filter :blocked
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :blocked
    column :confirmed_at
    actions do |user|
      if user.blocked?
        item "Разблокировать", unblock_admin_user_path(user), method: :put, class: "member_link"
      else
        item "Заблокировать", block_admin_user_path(user), method: :put, class: "member_link"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys
      f.input :blocked
      f.input :password, hint: "Оставьте пустым, чтобы не менять"
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :role
      row :blocked
      row :confirmed_at
      row :created_at
    end
  end

  member_action :block, method: :put do
    resource.update(blocked: true)
    redirect_to admin_user_path(resource), notice: "Пользователь заблокирован."
  end

  member_action :unblock, method: :put do
    resource.update(blocked: false)
    redirect_to admin_user_path(resource), notice: "Пользователь разблокирован."
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end
