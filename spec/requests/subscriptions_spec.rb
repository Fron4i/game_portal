require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  describe 'POST /games/:slug/subscriptions' do
    it 'редиректит гостя на форму логина' do
      expect {
        post "/games/#{game.slug}/subscriptions"
      }.not_to change(Subscription, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'создаёт подписку для пользователя' do
      sign_in user

      expect {
        post "/games/#{game.slug}/subscriptions"
      }.to change(Subscription, :count).by(1)
    end

    it 'не дублирует подписку при повторном POST' do
      sign_in user
      post "/games/#{game.slug}/subscriptions"

      expect {
        post "/games/#{game.slug}/subscriptions"
      }.not_to change(Subscription, :count)
    end
  end

  describe 'DELETE /games/:slug/subscriptions' do
    it 'отписывает пользователя' do
      sign_in user
      create(:subscription, user: user, game: game)

      expect {
        delete "/games/#{game.slug}/subscriptions"
      }.to change(Subscription, :count).by(-1)
    end
  end
end
