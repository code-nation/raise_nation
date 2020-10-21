require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) do
    allow_any_instance_of(RaiselyCampaign).to receive(:set_raisely_slug).and_return(true)
    create(:user, :with_all)
  end

  before { sign_in user }

  describe 'GET show' do
    let(:account) { user.accounts.first }

    before(:each) do
      get :show, params: { id: account.id }
    end

    it do
      expect(response).to have_http_status(:ok)
      expect(assigns(:account)).to eq account
      expect(assigns(:users)).to eq account.users
      expect(assigns(:nations)).to eq account.nations
      expect(assigns(:campaigns)).to eq account.raisely_campaigns
      expect(assigns(:user_invite_form)).to be_an_instance_of(UserInvitation)
    end
  end

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it do
      expect(response).to have_http_status(:ok)
      expect(assigns(:accounts)).to eq user.accounts
    end
  end

  describe 'GET new' do
    before(:each) do
      get :new
    end

    it do
      expect(response).to have_http_status(:ok)
      expect(assigns(:account)).to be_an_instance_of(Account)
    end
  end

  describe 'POST create' do
    let(:org_name) { Faker::Company.name }

    before(:each) do
      post :create, params: { account: { organisation_name: org_name } }
    end

    it do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
      expect(Account.last.organisation_name).to eq org_name
    end
  end
end
