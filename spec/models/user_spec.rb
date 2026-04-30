require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'валидации' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(40) }
  end

  describe 'роли' do
    it { is_expected.to define_enum_for(:role).with_values(user: 0, admin: 1) }

    it 'admin? — true для админа' do
      expect(build(:user, :admin)).to be_admin
    end

    it 'user? — true по умолчанию' do
      expect(build(:user)).to be_user
    end
  end

  describe '#active_for_authentication?' do
    it 'true для обычного юзера' do
      expect(build(:user).active_for_authentication?).to be true
    end

    it 'false для заблокированного' do
      expect(build(:user, :blocked).active_for_authentication?).to be false
    end
  end

  describe 'ассоциации' do
    it { is_expected.to have_many(:posts).with_foreign_key(:author_id) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:subscriptions) }
  end
end
