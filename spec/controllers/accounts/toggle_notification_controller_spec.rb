require 'rails_helper'

RSpec.describe Accounts::ToggleNotificationController, type: :controller do
  let(:user) { create(:user, :with_accounts) }
  before { sign_in user }

  describe 'PUT update' do
    let(:receive_notifications) { false }
    let!(:account_user) do
      au = user.account_users.first
      au.receive_notifications = receive_notifications
      au.save
      au
    end
    let(:account_id) { account_user.account_id }

    before(:each) do
      put :update, params: { id: account_id }
    end

    it 'Updates the receive notification to true' do
      expect(account_user.reload.receive_notifications).to eq true
      expect(response).to have_http_status(:no_content)
    end

    describe 'when already true' do
      let(:receive_notifications) { true }

      it 'Updates the receive notification to true' do
        expect(account_user.reload.receive_notifications).to eq false
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
