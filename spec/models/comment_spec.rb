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
end
