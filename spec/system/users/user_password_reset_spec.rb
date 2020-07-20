require 'rails_helper'

RSpec.describe 'User Password Reset', type: :system do
  let!(:user) { create(:user) }
  let(:email_input) { user.email }

  before(:each) do
    visit '/users/password/new'
    find('input#user_email').set(email_input)
    expect {
      click_on('Send me reset password instructions')
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'Prompts user for reset password instructions' do
    expect(page).to have_text('You will receive an email with instructions on how to reset your password in a few minutes.')
  end
end
