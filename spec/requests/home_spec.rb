require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    it 'возвращает 200 и показывает заголовки опубликованных постов' do
      published = create(:post, :published)
      create(:post, :draft)

      get '/'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(published.title)
    end

    it 'пагинирует ленту по 20 постов на страницу' do
      create_list(:post, 25, :published)

      get '/'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('page=2')

      get '/?page=2'
      expect(response).to have_http_status(:ok)
    end
  end
end
