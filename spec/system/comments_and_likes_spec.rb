require 'rails_helper'

RSpec.describe 'Комментарии и лайки', type: :system do
  before { driven_by(:selenium_chrome_headless) }

  let(:post_record) { create(:post, :published) }

  describe 'комментарий' do
    it 'добавляется через Turbo Stream и удаляется автором' do
      sign_in create(:user)
      visit "/posts/#{post_record.slug}"

      within('[data-test=comment-form]') do
        fill_in 'comment[body]', with: 'Огонь обновление'
        find('button[type=submit]').click
      end

      expect(page).to have_content('Огонь обновление')

      comment = Comment.last
      within("[data-test=comment-#{comment.id}]") do
        find('[data-test=comment-delete]').click
      end

      expect(page).to have_no_selector("[data-test=comment-#{comment.id}]")
    end
  end

  describe 'лайк поста' do
    it 'переключает счётчик 0 → 1 → 0' do
      sign_in create(:user)
      visit "/posts/#{post_record.slug}"

      expect(find('[data-test=post-likes-count]')).to have_text('0')

      find('[data-test=post-like]').click
      expect(find('[data-test=post-likes-count]')).to have_text('1')

      find('[data-test=post-like]').click
      expect(find('[data-test=post-likes-count]')).to have_text('0')
    end
  end

  describe 'лайк коммента' do
    it 'переключает счётчик внутри блока коммента' do
      author = create(:user)
      comment = create(:comment, post: post_record, user: author)

      sign_in create(:user)
      visit "/posts/#{post_record.slug}"

      within("[data-test=comment-#{comment.id}]") do
        expect(find('[data-test=comment-likes-count]')).to have_text('0')
        find('[data-test=comment-like]').click
        expect(find('[data-test=comment-likes-count]')).to have_text('1')
        find('[data-test=comment-like]').click
        expect(find('[data-test=comment-likes-count]')).to have_text('0')
      end
    end
  end

  describe 'модерация' do
    it 'админ удаляет чужой коммент' do
      foreigner = create(:user)
      comment = create(:comment, post: post_record, user: foreigner)

      sign_in create(:user, :admin)
      visit "/posts/#{post_record.slug}"

      within("[data-test=comment-#{comment.id}]") do
        find('[data-test=comment-delete]').click
      end

      expect(page).to have_no_selector("[data-test=comment-#{comment.id}]")
    end
  end
end
