require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'валидации' do
    subject { build(:game) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(80) }
  end

  describe 'ассоциации' do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:subscriptions) }
    it { is_expected.to have_many(:subscribers).through(:subscriptions) }
  end

  describe 'скоупы' do
    it '.released возвращает только релизнутые игры' do
      released = create(:game, released_at: 1.day.ago)
      create(:game, released_at: 1.day.from_now)
      expect(Game.released).to contain_exactly(released)
    end

    it '.latest сортирует по released_at desc' do
      old = create(:game, released_at: 2.months.ago)
      fresh = create(:game, released_at: 1.day.ago)
      expect(Game.latest.first(2)).to eq([fresh, old])
    end
  end

  describe 'friendly_id' do
    it 'генерирует slug из title' do
      game = create(:game, title: 'Halo Infinite')
      expect(game.slug).to eq('halo-infinite')
    end
  end
end
