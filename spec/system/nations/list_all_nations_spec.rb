require 'rails_helper'

RSpec.describe 'List all nations under an account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account) { user.accounts.first }
  let!(:nation) { create(:nation, account: account) }
  let!(:nation2) { create(:nation, account: account) }
  let!(:nation3) { create(:nation) }

  before(:each) do
    login_as(user, scope: :user)
  end

  it 'list all nations', js: true do
    visit "/accounts/#{account.id}"

    expect(page).to have_content('Nations listing')

    within('table.nations-listing') do
      expect(page).to have_content(nation.slug)
      expect(page).to have_content(nation2.slug)
      expect(page).not_to have_content(nation3.slug)
    end
  end
end
