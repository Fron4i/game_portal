require 'rails_helper'

RSpec.describe 'Подписки и лента', type: :system do
  before { driven_by(:selenium_chrome_headless) }

  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let!(:game_post) { create(:post, :published, game: game) }

  it 'юзер подписывается, видит пост в ленте, отписывается, лента пустеет' do
    sign_in user

    visit "/games/#{game.slug}"
    expect(page).to have_selector('[data-test=game-subscribe]')

    find('[data-test=game-subscribe]').click
    expect(page).to have_selector('[data-test=game-unsubscribe]')
    expect(page).to have_no_selector('[data-test=game-subscribe]')

    visit '/feed'
    expect(page).to have_selector("[data-test=feed-post-#{game_post.id}]")

    visit "/games/#{game.slug}"
    find('[data-test=game-unsubscribe]').click
    expect(page).to have_selector('[data-test=game-subscribe]')

    visit '/feed'
    expect(page).to have_no_selector("[data-test=feed-post-#{game_post.id}]")
    expect(page).to have_selector('[data-test=feed-empty]')
  end

  it 'не показывает в ленте посты неподписанных игр' do
    other_game = create(:game)
    other_post = create(:post, :published, game: other_game)
    create(:subscription, user: user, game: game)

    sign_in user
    visit '/feed'

    expect(page).to have_selector("[data-test=feed-post-#{game_post.id}]")
    expect(page).to have_no_selector("[data-test=feed-post-#{other_post.id}]")
  end
end
