require 'rails_helper'

RSpec.describe Accounts::InviteUserController, type: :controller do
  let(:user) { create(:user, :with_accounts) }
  before { sign_in user }

  describe 'POST create' do
    let(:email) { Faker::Internet.email }
    let(:account_id) { create(:account, user_id: user.id).id }

    let(:params) do
      {
        email: email,
        account_id: account_id
      }
    end

    before(:each) do
      request.headers.merge!('HTTP_REFERER' => root_path)
      post :create, params: { user_invitation: params }
    end

    it 'should redirect back with success notification' do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq "Sent invite to #{email}"
    end

    describe 'empty email' do
      let(:email) { nil }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq 'Email can\'t be blank'
      end
    end

    describe 'empty account_id' do
      let(:account_id) { nil }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq 'Account can\'t be blank'
      end
    end

    describe 'account with no user access' do
      let(:account_id) { create(:account) }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(
          'Account invitations can only be sent to users for existing accounts you\'re able to access'
        )
      end
    end

    describe 'non existing account' do
      let(:account_id) { 999 }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(
          'Account invitations can only be sent to users for existing accounts you\'re able to access'
        )
      end
    end
  end
end
