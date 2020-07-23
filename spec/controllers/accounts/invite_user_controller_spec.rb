require 'rails_helper'

RSpec.describe Accounts::InviteUserController, type: :controller do
  let(:user) { create(:user, :with_accounts) }
  before { sign_in user }

  describe 'POST create' do
    let(:email) { Faker::Internet.email }
    let(:account_id) { create(:account).id }
    let(:inviter_id) { user.id }

    let(:params) do
      {
        email: email,
        account_id: account_id,
        inviter_id: inviter_id
      }
    end

    before(:each) do
      request.headers.merge!('HTTP_REFERER' => root_path)
      post :create, params: { user_invite_form: params }
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

    describe 'non existing account' do
      let(:account_id) { 999 }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq 'Account provided is not existing'
      end
    end


    describe 'empty inviter_id' do
      let(:inviter_id) { nil }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq 'Inviter can\'t be blank'
      end
    end

    describe 'non existing inviter' do
      let(:inviter_id) { 999 }

      it 'should redirect back with failed notification' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq 'Inviter provided is not existing'
      end
    end
  end
end
