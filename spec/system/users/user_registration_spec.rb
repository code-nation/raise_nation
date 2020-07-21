require 'rails_helper'

RSpec.describe 'User Registration', type: :system do
  let(:email) { Faker::Internet.email }
  let(:password) { 'password' }
  let(:password_confirm) { 'password' }
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.first_name }

  before(:each) do
    visit '/users/sign_up'
    find('input#user_first_name').set(first_name)
    find('input#user_last_name').set(last_name)
    find('input#user_email').set(email)
    find('input#user_password').set(password)
    find('input#user_password_confirmation').set(password_confirm)

    click_on('Sign Up')
  end

  it 'successful sign up' do
    expect(page).to have_text('In order to continue you need to create an account first.')
    expect(User.where(email: email)).not_to be_empty
    expect(page.current_path).to eq('/accounts/new')
  end

  shared_examples_for 'unsuccessful sign up' do
    it do
      expect(page.current_path).to eq('/users')
      expect(User.where(email: email)).to be_empty
    end
  end

  describe 'empty email' do
    let(:email) { '' }

    it_behaves_like 'unsuccessful sign up'
  end

  describe 'empty password' do
    let(:password) { '' }

    it_behaves_like 'unsuccessful sign up'
  end

  describe 'unmatched password and password confirm' do
    let(:password_confirm) { 'incorrectpassword' }

    it_behaves_like 'unsuccessful sign up'
  end
end
