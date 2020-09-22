require 'rails_helper'

RSpec.describe Accounts::RaiselyCampaignsController, type: :controller do
  let(:user) { create(:user, :with_accounts) }
  let(:account) { user.accounts.first }
  before { sign_in user }

  describe 'GET new' do
    subject { get :new, params: { account_id: account.id } }

    it 'should render with no layout' do
      expect(subject).to render_template(layout: nil)
      expect(subject).to have_http_status(:ok)
      expect(assigns(:campaign)).to be_an_instance_of(RaiselyCampaign)
      expect(assigns(:campaign).account).to eq account
    end
  end

  describe 'POST create' do
    let(:campaign_uuid) { SecureRandom.uuid }
    let(:name) { Faker::Company.name }
    let(:api_key) { SecureRandom.uuid }

    it 'should create a nation' do
      post :create, params: {
        account_id: account.id,
        raisely_campaign: { name: name, campaign_uuid: campaign_uuid, api_key: api_key }
      }

      expect(response).to have_http_status(:redirect)
      expect(assigns(:campaign)).to be_an_instance_of(RaiselyCampaign)
      expect(assigns(:campaign).account).to eq account
      expect(assigns(:campaign).persisted?).to eq true
      expect(response).to redirect_to("/accounts/#{account.id}")
      expect(assigns(:campaign).campaign_uuid).to eq campaign_uuid
      expect(assigns(:campaign).api_key).to eq api_key
    end

    describe 'existing campaign_uuid' do
      let!(:campaign) { create(:raisely_campaign, campaign_uuid: campaign_uuid) }

      it 'should create a nation' do
        post :create, params: {
          account_id: account.id,
          raisely_campaign: { campaign_uuid: campaign_uuid, api_key: api_key }
        }

        expect(response).to have_http_status(:redirect)
        expect(assigns(:campaign)).to be_an_instance_of(RaiselyCampaign)
        expect(assigns(:campaign).account).to eq account
        expect(response).to redirect_to("/accounts/#{account.id}")
        expect(assigns(:campaign).persisted?).to eq false
      end
    end
  end
end
