require 'rails_helper'

RSpec.describe 'Select account', type: :system do
  let!(:user) { create(:user) }
  let(:org_name) { Faker::Company.name }

  before(:each) do
    login_as(user, scope: :user)
    visit '/accounts/new'

    find('input#account_organisation_name').set(org_name)
    click_on('Save')
  end

  it 'Updates the selected account' do
    expect(Account.where(organisation_name: org_name)).not_to be_empty
    expect(page).to have_content('Account was successfully created.')
    expect(page.current_path).to eq('/')
  end

  describe 'Empty org name' do
    let(:org_name) { '' }

    it 'No org saved' do
      expect(Account.where(organisation_name: org_name)).to be_empty
      expect(page).not_to have_content('Account was successfully created.')
      expect(page.current_path).to eq('/accounts')
    end
  end
end
