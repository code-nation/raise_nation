require 'rails_helper'

RSpec.describe 'Send invite to join account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account1) { create(:account, user_id: user.id) }

  before(:each) do
    login_as(user, scope: :user)
  end

  it 'should invite user via email', js: true do
    email = 'tst@tst.com'

    visit "/accounts/#{account1.id}"

    expect(page).to have_content('Send Invite')

    within('div.account-listing-controls') do
      find('a.user-invite').click
    end

    within('div.modal-dialog') do
      expect(page).to have_content('Invite User to Account')
      find('input#user_invitation_email').set(email)
      find('input.user-invite-submit').click
    end

    expect(page).to have_content("Sent invite to #{email}")
  end
end
