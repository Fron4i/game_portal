require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts/:slug' do
    it 'возвращает 200 и показывает заголовок поста' do
      post = create(:post, :published, title: 'Crimson Update Notes')

      get "/posts/#{post.slug}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post.title)
    end

    it 'отдаёт 404 на несуществующий slug' do
      get '/posts/unknown-post-slug'

      expect(response).to have_http_status(:not_found)
    end
  end
end
