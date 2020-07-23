require 'rails_helper'

RSpec.describe Settings::ProfileController, type: :controller do
  let(:user) { create(:user, :with_accounts) }
  before { sign_in user }

  describe 'PUT update' do
    let(:first_name) { 'Charles' }
    let(:last_name) { 'Babbage' }
    let(:email) { 'someemail@test.com' }
    let(:current_password) { '' }
    let(:password) { '' }
    let(:password_confirmation) { '' }

    let(:params) do
      {
        id: user.id,
        user: {
          first_name: first_name,
          last_name: last_name,
          email: email,
          current_password: current_password,
          password: password,
          password_confirmation: password_confirmation
        }
      }
    end

    before(:each) do
      put :update, params: params
    end

    it 'succesfully updated user' do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq 'Profile successfully updated.'
      user.reload
      expect(user.first_name).to eq first_name
      expect(user.last_name).to eq last_name
      expect(user.email).to eq email
      expect(user.valid_password?(password)).to eq false
    end

    describe 'password update' do
      let(:user) { create(:user, :with_accounts, password: 'P@ssw0rd!') }
      let(:current_password) { 'P@ssw0rd!' }
      let(:password) { 'Upd@t3dP@ss' }
      let(:password_confirmation) { 'Upd@t3dP@ss' }

      it 'succesfully updated user and password' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq 'Profile successfully updated.'
        user.reload
        expect(user.first_name).to eq first_name
        expect(user.last_name).to eq last_name
        expect(user.email).to eq email
        expect(user.valid_password?(password)).to eq true
      end

      describe 'incorrect password confirmation' do
        let(:password_confirmation) { 'IncorrectP@ss' }

        it 'not succesfully updated user and password' do
          expect(response).to have_http_status(:ok)
          user.reload
          expect(user.first_name).not_to eq first_name
          expect(user.last_name).not_to eq last_name
          expect(user.email).not_to eq email
          expect(user.valid_password?(password)).not_to eq true
        end
      end
    end
  end
end
