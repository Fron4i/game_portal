require 'rails_helper'

RSpec.describe 'Админка', type: :system do
  before { driven_by(:selenium_chrome_headless) }

  let(:admin) { create(:user, :admin) }

  def submit_form
    find('input[type=submit], button[type=submit]', match: :first).click
  end

  describe 'публикация поста' do
    it 'админ создаёт пост и видит его на главной' do
      game = create(:game, title: 'Halo Infinite')
      sign_in admin

      visit '/admin/posts/new'
      select game.title, from: 'post[game_id]'
      select admin.email, from: 'post[author_id]'
      fill_in 'post[title]', with: 'Анонс новой кампании'
      select 'announcement', from: 'post[kind]'

      editor = find('trix-editor[input=post_body]')
      editor.click
      editor.send_keys('Скоро встретимся в новой кампании.')

      submit_form

      visit '/'
      expect(page).to have_content('Анонс новой кампании')
    end
  end

  describe 'модерация коммента' do
    it 'админ удаляет чужой коммент через ActiveAdmin' do
      post_record = create(:post, :published)
      comment = create(:comment, post: post_record, body: 'Грубый коммент')

      sign_in admin
      accept_confirm do
        visit '/admin/comments'
        within("#comment_#{comment.id}, tr[data-id='#{comment.id}']") do
          find('a.delete_link, a[data-method=delete], a[data-turbo-method=delete]', match: :first).click
        end
      end

      visit "/posts/#{post_record.slug}"
      expect(page).to have_no_content('Грубый коммент')
    end
  end

  describe 'бан юзера' do
    it 'заблокированный юзер не входит в систему' do
      victim = create(:user, password: 'password123', password_confirmation: 'password123')

      sign_in admin
      visit "/admin/users/#{victim.id}/edit"
      check 'user[blocked]'
      submit_form

      Capybara.reset_sessions!

      visit new_user_session_path
      fill_in 'user[email]', with: victim.email
      fill_in 'user[password]', with: 'password123'
      submit_form

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content(/заблокир/i)
    end
  end

  describe 'обычный юзер в /admin' do
    it 'не получает доступ к админке' do
      sign_in create(:user)
      visit '/admin'

      expect(page).to have_no_current_path('/admin')
    end
  end
end
