require 'rails_helper'

RSpec.describe UserInvitation, type: :model do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account) { user.accounts.first }
  let(:email) { Faker::Internet.email }

  before(:each) { allow_any_instance_of(UserInvitation).to receive(:inviter).and_return(user) }
  subject { UserInvitation.new(account_id: account.id, inviter_id: user.id, email: email) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :account_id }
  it { should validate_presence_of :inviter_id }

  describe '#check_email_user' do
    describe 'email already have access' do
      let!(:email) do
        user = create(:user)
        user.accounts << account
        user.email
      end

      before(:each) { subject.valid? }

      it { expect(subject.errors.messages[:email]).to eq(['already have access to this account']) }
    end
  end

  describe '#check_account' do
    describe 'account not accessible for user' do
      let!(:account) { create(:account) }

      before(:each) { subject.valid? }

      it do
        expect(subject.errors.messages[:account_id]).to eq(
          ['invitations can only be sent to users for existing accounts you\'re able to access']
        )
      end
    end

    describe 'account is not existing at all' do
      subject { UserInvitation.new(account_id: 999, inviter_id: user.id, email: email) }

      before(:each) { subject.valid? }

      it do
        expect(subject.errors.messages[:account_id]).to eq(
          ['invitations can only be sent to users for existing accounts you\'re able to access']
        )
      end
    end
  end
end
