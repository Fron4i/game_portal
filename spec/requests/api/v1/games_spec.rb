require 'rails_helper'

RSpec.describe 'API V1 Games', type: :request do
  let(:headers) { { 'Accept' => 'application/json' } }

  describe 'GET /api/v1/games' do
    it 'возвращает массив data и pagy-мету' do
      create_list(:game, 3)

      get '/api/v1/games', headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
      expect(json.dig('meta', 'pages')).to be_a(Integer)
    end

    it 'отдаёт более одной страницы при 25+ играх' do
      create_list(:game, 25)

      get '/api/v1/games', headers: headers

      json = JSON.parse(response.body)
      expect(json.dig('meta', 'pages')).to be > 1
    end
  end

  describe 'GET /api/v1/games/:slug' do
    it 'возвращает атрибуты игры и ключ cover_url' do
      game = create(:game, title: 'Halo Infinite')

      get "/api/v1/games/#{game.slug}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.dig('data', 'attributes', 'title')).to eq('Halo Infinite')
      expect(json['data']['attributes']).to have_key('cover_url')
    end

    it 'возвращает 404 на неизвестный slug' do
      get '/api/v1/games/unknown-slug', headers: headers

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq('error' => 'not_found')
    end
  end
end
