require 'rails_helper'

RSpec.describe 'Select account', type: :system do
  let!(:account1) { create(:account, user_id: user.id) }
  let!(:account2) { create(:account, user_id: user.id) }
  let!(:account3) { create(:account, user_id: user.id) }

  let!(:user) { create(:user) }

  before(:each) do
    login_as(user, scope: :user)
  end

  it 'Updates the selected account', js: true do
    visit '/'
    expect(find('button.accounts-dropdown')).to have_content(account1[:organisation_name])

    find('button.accounts-dropdown').click
    within('.accounts-list-menu') do
      find("a.dropdown-item[href='#{settings_update_current_account_path(id: account2.id)}']").click
    end

    expect(find('button.accounts-dropdown')).to have_content(account2[:organisation_name])
  end
end
