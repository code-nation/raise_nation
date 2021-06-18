require 'rails_helper'

RSpec.describe 'Add campaign under an account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account) { user.accounts.first }
  let(:name) { Faker::Company.name }
  let(:campaign_uuid) { SecureRandom.uuid }
  let(:api_key) { SecureRandom.uuid }

  before(:each) do
    allow_any_instance_of(RaiselyCampaign).to receive(:set_raisely_slug_and_profile_uuid).and_return(true)
    login_as(user, scope: :user)
  end

  it 'should add campaign', js: true do
    visit "/accounts/#{account.id}"

    expect(page).to have_content('Add Campaign')

    within('div.raisely-campaigns-listing-controls') do
      find('a.add-campaign').click
    end

    within('div.modal-dialog') do
      expect(page).to have_content('Add Campaign')
      find('input#raisely_campaign_name').set(name)
      find('input#raisely_campaign_campaign_uuid').set(campaign_uuid)
      find('input#raisely_campaign_api_key').set(api_key)
      find('input.add-campaign-submit').click
    end

    expect(page).to have_content('Campaign successfully created')
  end

  describe 'existing campaign_uuid' do
    let!(:campaign) { create(:raisely_campaign, campaign_uuid: campaign_uuid) }

    it 'should not add campaign', js: true do
      visit "/accounts/#{account.id}"

      expect(page).to have_content('Add Campaign')

      within('div.raisely-campaigns-listing-controls') do
        find('a.add-campaign').click
      end

      within('div.modal-dialog') do
        expect(page).to have_content('Add Campaign')
        find('input#raisely_campaign_campaign_uuid').set(campaign_uuid)
        find('input#raisely_campaign_api_key').set(api_key)
        find('input.add-campaign-submit').click
      end

      expect(page).not_to have_content('Campaign successfully created')
      expect(page).to have_content('Campaign uuid has already been taken')
    end
  end
end
