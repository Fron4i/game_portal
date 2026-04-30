require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'ассоциации' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:game) }
  end

  describe 'уникальность (user, game)' do
    it 'не позволяет дубль' do
      user = create(:user)
      game = create(:game)
      create(:subscription, user: user, game: game)
      duplicate = build(:subscription, user: user, game: game)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'User#subscribed_to?' do
    it 'true для подписанной игры' do
      user = create(:user)
      game = create(:game)
      create(:subscription, user: user, game: game)
      expect(user.subscribed_to?(game)).to be true
    end

    it 'false для неподписанной' do
      expect(create(:user).subscribed_to?(create(:game))).to be false
    end
  end
end
