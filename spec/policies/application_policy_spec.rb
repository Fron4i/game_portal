require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject { described_class.new(user, :record) }

  let(:default_actions) { %i[index show create new update edit destroy] }

  context 'для гостя' do
    let(:user) { nil }
    it { is_expected.to forbid_actions(default_actions) }
  end

  context 'для пользователя' do
    let(:user) { build_stubbed(:user) }
    it { is_expected.to forbid_actions(default_actions) }
  end

  context 'для админа' do
    let(:user) { build_stubbed(:user, :admin) }
    it { is_expected.to forbid_actions(default_actions) }
  end
end
