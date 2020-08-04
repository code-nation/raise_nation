require 'rails_helper'

RSpec.describe Accounts::NationsController, type: :controller do
  let(:user) { create(:user, :with_accounts) }
  let(:account) { user.accounts.first }
  before { sign_in user }

  describe 'GET new' do
    subject { get :new, params: { account_id: account.id } }

    it 'should render with no layout' do
      expect(subject).to render_template(layout: nil)
      expect(subject).to have_http_status(:ok)
      expect(assigns(:nation)).to be_an_instance_of(Nation)
      expect(assigns(:nation).account).to eq account
    end
  end

  describe 'POST create' do
    let(:slug) { 'Some Org' }

    it 'should create a nation' do
      post :create, params: { account_id: account.id, nation: { slug: slug } }
      expect(response).to have_http_status(:redirect)
      expect(assigns(:nation)).to be_an_instance_of(Nation)
      expect(assigns(:nation).account).to eq account
      expect(assigns(:nation).persisted?).to eq true
      expect(response).to redirect_to("/accounts/nations/#{assigns(:nation).id}/connect")
      expect(assigns(:nation).slug).to eq slug
    end

    describe 'existing slug' do
      let!(:nation) { create(:nation, slug: slug) }

      it 'should create a nation' do
        post :create, params: { account_id: account.id, nation: { slug: slug } }
        expect(response).to have_http_status(:redirect)
        expect(assigns(:nation)).to be_an_instance_of(Nation)
        expect(assigns(:nation).account).to eq account
        expect(response).to redirect_to("/accounts/#{account.id}")
        expect(assigns(:nation).persisted?).to eq false
      end
    end
  end
end
