require 'rails_helper'

RSpec.describe 'API V1 Posts', type: :request do
  let(:headers) { { 'Accept' => 'application/json' } }

  describe 'GET /api/v1/posts' do
    it 'сортирует по published_at desc' do
      old = create(:post, :published, published_at: 2.weeks.ago)
      fresh = create(:post, :published, published_at: 1.day.ago)

      get '/api/v1/posts', headers: headers

      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body)['data'].map { |item| item['id'].to_i }
      expect(ids.first(2)).to eq([fresh.id, old.id])
    end
  end

  describe 'GET /api/v1/posts/:slug' do
    it 'возвращает body_html, likes_count и массив comments' do
      author = create(:user, name: 'Иван')
      post_record = create(:post, :published, author: author)
      create(:comment, post: post_record, body: 'Отличный анонс')

      get "/api/v1/posts/#{post_record.slug}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      attributes = json.dig('data', 'attributes')

      expect(attributes['body_html']).to be_a(String)
      expect(attributes['likes_count']).to be_a(Integer)

      comments = attributes['comments']
      expect(comments).to be_an(Array)
      expect(comments.first).to include('body' => 'Отличный анонс')
      expect(comments.first).to have_key('user_name')
    end

    it 'возвращает 404 на неизвестный slug' do
      get '/api/v1/posts/unknown-slug', headers: headers

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq('error' => 'not_found')
    end
  end
end
