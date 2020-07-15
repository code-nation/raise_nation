require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

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

    context 'no org name' do
      let(:org_name) { nil }

      it do
        expect(response).to have_http_status(:ok)
        expect(Account.count).to eq 0
        expect(Account.last&.organisation_name).to eq nil
      end
    end
  end
end
