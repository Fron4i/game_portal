require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  shared_examples 'идемпотентный лайк' do |type_name, factory|
    let(:target) { create(factory) }
    let(:params) { { likeable_type: type_name, likeable_id: target.id } }

    it 'создаёт лайк' do
      expect {
        post '/likes', params: params
      }.to change(Like, :count).by(1)
    end

    it 'не дублирует лайк при повторе' do
      post '/likes', params: params
      expect {
        post '/likes', params: params
      }.not_to change(Like, :count)
    end

    it 'удаляет лайк' do
      post '/likes', params: params
      expect {
        delete '/likes', params: params
      }.to change(Like, :count).by(-1)
    end

    it 'не падает на повторном удалении' do
      post '/likes', params: params
      delete '/likes', params: params
      expect {
        delete '/likes', params: params
      }.not_to change(Like, :count)
    end
  end

  describe 'для Post' do
    include_examples 'идемпотентный лайк', 'Post', :post
  end

  describe 'для Comment' do
    include_examples 'идемпотентный лайк', 'Comment', :comment
  end
end
