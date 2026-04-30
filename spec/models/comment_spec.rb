require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'валидации' do
    subject { build(:comment) }

    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_least(2).is_at_most(2000) }
  end

  describe 'ассоциации' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
    it { is_expected.to have_many(:likes) }
  end

  describe 'скоупы' do
    it '.recent — новые комменты первыми' do
      old = create(:comment, created_at: 2.days.ago)
      fresh = create(:comment, created_at: 1.hour.ago)
      expect(Comment.recent.first(2)).to eq([fresh, old])
    end
  end
end
