require 'rails_helper'

RSpec.describe Settings::UpdateCurrentAccountController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'PUT update' do
    let!(:account1) { user.owned_accounts.create(attributes_for(:account)) }
    let!(:account2) { user.owned_accounts.create(attributes_for(:account)) }
    let(:account_id) { account1.id }

    before(:each) do
      request.headers.merge!('HTTP_REFERER' => root_path)
      put :update, params: { id: account_id }
    end

    it do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to root_path
      expect(session[:current_account_id]).to eq account1.id
    end

    context 'different account id' do
      let(:account_id) { account2.id }

      it do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
        expect(session[:current_account_id]).to eq account2.id
      end
    end
  end
end
