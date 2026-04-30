require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'валидации' do
    subject { build(:post) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(3).is_at_most(140) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'enum kind' do
    it { is_expected.to define_enum_for(:kind).with_values(announcement: 0, update: 1).with_prefix(:kind) }
  end

  describe 'ассоциации' do
    it { is_expected.to belong_to(:game) }
    it { is_expected.to belong_to(:author).class_name('User').optional }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:likes) }
  end

  describe 'скоупы' do
    it '.published — только опубликованные' do
      published = create(:post, :published, published_at: 1.day.ago)
      create(:post, :draft)
      expect(Post.published).to contain_exactly(published)
    end

    it '.drafts — только черновики' do
      draft = create(:post, :draft)
      create(:post, :published)
      expect(Post.drafts).to contain_exactly(draft)
    end

    it '.for_game отбирает по игре' do
      game = create(:game)
      target = create(:post, game: game)
      other = create(:post)
      expect(Post.for_game(game)).to include(target)
      expect(Post.for_game(game)).not_to include(other)
    end

    it '.latest сортирует по published_at desc' do
      old = create(:post, published_at: 2.weeks.ago)
      fresh = create(:post, published_at: 1.day.ago)
      expect(Post.latest.first(2)).to eq([fresh, old])
    end
  end

  describe 'friendly_id' do
    it 'генерирует slug из title' do
      post = create(:post, title: 'New Game Update')
      expect(post.slug).to be_present
    end
  end
end
