require 'rails_helper'

RSpec.describe 'Аутентификация', type: :system do
  before { driven_by(:selenium_chrome_headless) }

  let(:email) { 'auth@iwebix.test' }
  let(:password) { 'password123' }

  def submit_form
    find('input[type=submit], button[type=submit]', match: :first).click
  end

  def fill_credentials(email_value:, password_value:)
    fill_in 'user[email]', with: email_value
    fill_in 'user[password]', with: password_value
  end

  describe 'регистрация → подтверждение → логин' do
    it 'отправляет письмо подтверждения, активирует учётку, пускает в систему' do
      visit new_user_registration_path
      fill_in 'user[name]', with: 'Тестер'
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      submit_form

      delivery = ActionMailer::Base.deliveries.last
      expect(delivery).to be_present
      expect(delivery.to).to include(email)

      confirm_url = delivery.body.encoded[%r{https?://[^"\s]+confirmation[^"\s]+}]
      expect(confirm_url).to be_present
      visit confirm_url

      expect(User.find_by(email: email).confirmed_at).to be_present

      visit new_user_session_path
      fill_credentials(email_value: email, password_value: password)
      submit_form

      expect(page).to have_no_current_path(new_user_session_path)
    end
  end

  describe 'выход' do
    it 'после выхода защищённые страницы недоступны' do
      user = create(:user)
      visit new_user_session_path
      fill_credentials(email_value: user.email, password_value: 'password123')
      submit_form

      find('a[data-turbo-method=delete][href*="sign_out"]').click

      visit '/feed'
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe 'восстановление пароля' do
    it 'присылает ссылку, после смены пароля пускает с новым паролем' do
      user = create(:user, password: 'oldpassword', password_confirmation: 'oldpassword')

      visit new_user_password_path
      fill_in 'user[email]', with: user.email
      submit_form

      reset_url = ActionMailer::Base.deliveries.last.body.encoded[%r{https?://[^"\s]+reset_password_token[^"\s]+}]
      expect(reset_url).to be_present
      visit reset_url

      fill_in 'user[password]', with: 'newpassword'
      fill_in 'user[password_confirmation]', with: 'newpassword'
      submit_form

      visit new_user_session_path
      fill_credentials(email_value: user.email, password_value: 'newpassword')
      submit_form

      expect(page).to have_no_current_path(new_user_session_path)
    end
  end

  describe 'блокировка' do
    it 'не пускает заблокированного пользователя' do
      user = create(:user, :blocked)

      visit new_user_session_path
      fill_credentials(email_value: user.email, password_value: 'password123')
      submit_form

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content(/заблокир/i)
    end
  end
end
