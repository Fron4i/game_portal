require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:post_record) { create(:post, :published) }

  describe 'POST /posts/:slug/comments' do
    let(:params) { { comment: { body: 'Хорошее обновление' } } }

    it 'редиректит гостя на форму логина и не создаёт коммент' do
      expect {
        post "/posts/#{post_record.slug}/comments", params: params
      }.not_to change(Comment, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'создаёт коммент авторизованного пользователя' do
      sign_in create(:user)

      expect {
        post "/posts/#{post_record.slug}/comments", params: params
      }.to change(Comment, :count).by(1)
    end
  end

  describe 'DELETE /posts/:slug/comments/:id' do
    let(:author) { create(:user) }
    let!(:comment) { create(:comment, user: author, post: post_record) }

    it 'удаляет свой коммент' do
      sign_in author

      expect {
        delete "/posts/#{post_record.slug}/comments/#{comment.id}"
      }.to change(Comment, :count).by(-1)
    end

    it 'не удаляет чужой коммент' do
      sign_in create(:user)

      expect {
        delete "/posts/#{post_record.slug}/comments/#{comment.id}"
      }.not_to change(Comment, :count)
    end

    it 'позволяет админу удалить чужой коммент' do
      sign_in create(:user, :admin)

      expect {
        delete "/posts/#{post_record.slug}/comments/#{comment.id}"
      }.to change(Comment, :count).by(-1)
    end
  end
end
