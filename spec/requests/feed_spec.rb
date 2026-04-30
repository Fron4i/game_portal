require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  describe 'GET /feed' do
    it 'редиректит гостя на форму логина' do
      get '/feed'

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'отдаёт 200 пользователю без подписок' do
      sign_in create(:user)

      get '/feed'

      expect(response).to have_http_status(:ok)
    end

    it 'показывает посты подписанных игр и не показывает чужие' do
      user = create(:user)
      subscribed = create(:game)
      other = create(:game)
      mine = create(:post, :published, game: subscribed, title: 'Subscribed Game Update')
      foreign = create(:post, :published, game: other, title: 'Foreign Game Update')
      create(:subscription, user: user, game: subscribed)

      sign_in user
      get '/feed'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(mine.title)
      expect(response.body).not_to include(foreign.title)
    end
  end
end
