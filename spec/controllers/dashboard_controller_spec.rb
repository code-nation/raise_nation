require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to new_account_path
    end

    context 'account available' do
      let(:user) do
        user = create(:user)
        user.owned_accounts.create(attributes_for(:account))
        user
      end

      it do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
