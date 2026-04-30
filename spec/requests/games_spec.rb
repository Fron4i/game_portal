require 'rails_helper'

RSpec.describe 'Games', type: :request do
  describe 'GET /games/:slug' do
    it 'возвращает 200 и показывает заголовок игры' do
      game = create(:game, title: 'Halo Infinite')

      get "/games/#{game.slug}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(game.title)
    end

    it 'отдаёт 404 на несуществующий slug' do
      get '/games/unknown-game-slug'

      expect(response).to have_http_status(:not_found)
    end
  end
end
