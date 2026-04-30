require 'rails_helper'

RSpec.describe LikePolicy do
  subject { described_class.new(user, build_stubbed(:like)) }

  context 'для гостя' do
    let(:user) { nil }
    it { is_expected.to forbid_actions(%i[create? destroy?]) }
  end

  context 'для пользователя' do
    let(:user) { build_stubbed(:user) }
    it { is_expected.to permit_actions(%i[create? destroy?]) }
  end

  context 'для админа' do
    let(:user) { build_stubbed(:user, :admin) }
    it { is_expected.to permit_actions(%i[create? destroy?]) }
  end
end
