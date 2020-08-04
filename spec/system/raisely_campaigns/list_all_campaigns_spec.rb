require 'rails_helper'

RSpec.describe 'List all campaigns under an account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account) { user.accounts.first }
  let!(:campaign) { create(:raisely_campaign, account: account) }
  let!(:campaign2) { create(:raisely_campaign, account: account) }
  let!(:campaign3) { create(:raisely_campaign) }

  before(:each) do
    login_as(user, scope: :user)
  end

  it 'list all nations', js: true do
    visit "/accounts/#{account.id}"

    expect(page).to have_content('Nations listing')

    within('table.raisely-campaigns-listing') do
      expect(page).to have_content(campaign.campaign_uuid)
      expect(page).to have_content(campaign2.campaign_uuid)
      expect(page).not_to have_content(campaign3.campaign_uuid)
    end
  end
end
