require 'rails_helper'

RSpec.describe ProfilePolicy do
  subject { described_class.new(user, user) }

  context 'для гостя' do
    let(:user) { nil }
    it { is_expected.to forbid_action(:show?) }
  end

  context 'для пользователя' do
    let(:user) { build_stubbed(:user) }
    it { is_expected.to permit_action(:show?) }
  end

  context 'для админа' do
    let(:user) { build_stubbed(:user, :admin) }
    it { is_expected.to permit_action(:show?) }
  end
end
