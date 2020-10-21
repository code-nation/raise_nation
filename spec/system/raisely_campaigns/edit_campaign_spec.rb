require 'rails_helper'

RSpec.describe 'Edit a campaign under an account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account) { user.accounts.first }
  let(:api_key) { SecureRandom.uuid }
  let(:updated_api_key) { SecureRandom.uuid }
  let!(:campaign) do
    camp = build(:raisely_campaign, account: account, api_key: api_key)
    allow(camp).to receive(:set_raisely_slug).and_return(true)
    camp.save
    camp
  end

  before(:each) do
    allow_any_instance_of(RaiselyCampaign).to receive(:set_raisely_slug).and_return(true)
    login_as(user, scope: :user)
  end

  it 'should add campaign', js: true do
    visit "/accounts/#{account.id}"

    expect(page).to have_content('Add Campaign')

    find("a.edit-campaign-btn-#{campaign.id}").click

    within('div.modal-dialog') do
      expect(page).to have_content('Update Campaign')
      find('input#raisely_campaign_api_key').set(updated_api_key)
      find('input.update-campaign-submit').click
    end

    expect(page).to have_content('Campaign was successfully updated')
    expect(campaign.reload.api_key).to eq updated_api_key
  end

  describe 'blank api key' do
    let(:updated_api_key) { '' }

    it 'should add campaign', js: true do
      visit "/accounts/#{account.id}"

      expect(page).to have_content('Add Campaign')

      find("a.edit-campaign-btn-#{campaign.id}").click

      within('div.modal-dialog') do
        expect(page).to have_content('Update Campaign')
        find('input#raisely_campaign_api_key').set(updated_api_key)
        find('input.update-campaign-submit').click
      end

      expect(page).to have_content("Api key can't be blank")
      expect(campaign.reload.api_key).to eq api_key
    end
  end
end
