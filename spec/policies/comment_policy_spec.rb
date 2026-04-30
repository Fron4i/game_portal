require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class.new(user, comment) }

  let(:author) { build_stubbed(:user) }
  let(:other) { build_stubbed(:user) }
  let(:admin) { build_stubbed(:user, :admin) }
  let(:comment) { build_stubbed(:comment, user: author) }

  context 'для гостя' do
    let(:user) { nil }
    it { is_expected.to forbid_actions(%i[create destroy]) }
  end

  context 'для автора коммента' do
    let(:user) { author }
    it { is_expected.to permit_actions(%i[create destroy]) }
  end

  context 'для чужого пользователя' do
    let(:user) { other }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'для админа' do
    let(:user) { admin }
    it { is_expected.to permit_actions(%i[create destroy]) }
  end
end
