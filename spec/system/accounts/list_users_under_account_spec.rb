require 'rails_helper'

RSpec.describe 'List users under an account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:account1) do
    acc = create(:account, user_id: user.id)
    acc.users << user2
    acc
  end

  before(:each) do
    login_as(user, scope: :user)
  end

  it 'List users under the account' do
    visit "/accounts/#{account1.id}"

    expect(page).to have_content('User listing')

    within('div.table-responsive') do
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(user.preferred_name)
      expect(page).to have_content(user2.full_name)
      expect(page).to have_content(user2.preferred_name)
      expect(page).not_to have_content(user3.full_name)
      expect(page).not_to have_content(user3.preferred_name)
    end
  end
end
