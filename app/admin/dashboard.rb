ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Posts" do
          ul do
            Post.order(created_at: :desc).limit(10).map do |post|
              li link_to(post.title, admin_post_path(post))
            end
          end
        end
      end

      column do
        panel "Games" do
          ul do
            Game.order(created_at: :desc).limit(10).map do |game|
              li link_to(game.title, admin_game_path(game))
            end
          end
        end
      end
    end
  end
end
