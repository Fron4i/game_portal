require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'ассоциации' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:likeable) }
  end

  describe 'полиморфия' do
    it 'принимает Post в likeable' do
      post = create(:post)
      like = create(:like, for_post: post)
      expect(like.likeable).to eq(post)
    end

    it 'принимает Comment в likeable' do
      comment = create(:comment)
      like = create(:like, for_comment: comment)
      expect(like.likeable).to eq(comment)
    end
  end

  describe 'уникальность (user, likeable)' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    it 'не позволяет дубль через валидацию' do
      create(:like, user: user, for_post: post)
      duplicate = build(:like, user: user, for_post: post)
      expect(duplicate).not_to be_valid
    end

    it 'падает на БД-уник при обходе валидации' do
      create(:like, user: user, for_post: post)
      duplicate = build(:like, user: user, for_post: post)
      expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
