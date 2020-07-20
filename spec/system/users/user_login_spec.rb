require 'rails_helper'

RSpec.describe 'User Login', type: :system do
  let!(:user) { create(:user, password: password) }
  let!(:password) { 'P@ssw0rd!' }
  let(:password_input) { password }
  let(:email_input) { user.email }

  before(:each) do
    visit '/'

    find('input.email').set(email_input)
    find('input.password').set(password_input)
    click_button 'Log in'
  end

  it 'Signs me up successfully' do
    expect(page).to have_text('In order to continue you need to create an account first.')
  end

  shared_examples_for 'not login successfully' do
    it  do
      expect(page). to have_text('Invalid Email or password.')
    end
  end

  describe 'incorrect password' do
    let(:password_input) { 'incorrectpassword' }

    it_behaves_like 'not login successfully'
  end

  describe 'incorrect email' do
    let(:email_input) { 'incorrectemail@test.com' }

    it_behaves_like 'not login successfully'
  end
end
