require 'rails_helper'

RSpec.describe 'List accounts via dropdown', type: :system do
  let(:account1) { attributes_for(:account) }
  let(:account2) { attributes_for(:account) }
  let(:account3) { attributes_for(:account) }
  let(:other_account) do
    account = create(:account)
    create(:account_user, account: account, user: user)
    account
  end

  let!(:user) do
    user = create(:user)
    user.owned_accounts.create(account1)
    user.owned_accounts.create(account2)
    user.owned_accounts.create(account3)
    user
  end

  before(:each) do
    other_account
    login_as(user, scope: :user)
  end

  it 'List accounts via nav dropdown', js: true do
    visit '/'
    expect(find('button.accounts-dropdown')).to have_content(account1[:organisation_name])

    find('button.accounts-dropdown').click
    within('.accounts-list-menu') do
      expect(page).to have_content('Create a New Account')
      expect(page).to have_content(account2[:organisation_name])
      expect(page).to have_content(account3[:organisation_name])
      expect(page).to have_content(other_account[:organisation_name])
    end
  end
end
