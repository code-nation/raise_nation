require 'rails_helper'

RSpec.describe 'User Login', type: :system do
  let!(:user) { create(:user, password: password) }
  let!(:password) { 'P@ssw0rd!' }

  it 'Signs me up successfully' do
    visit '/'

    find('input.email').set(user.email)
    find('input.password').set(password)
    click_button 'Log in'

    expect(page).to have_text('Signed in successfully')
  end
end
