require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:account_users) }
  it { should have_many(:accounts) }
  it { should have_many(:owned_accounts).class_name('Account').inverse_of(:owner) }

  context '#methods' do
    let(:user) { build(:user) }

    describe '#full_name' do
      it { expect(user.full_name).to eq([user.first_name, user.last_name].join(' ')) }
    end

    describe '#first_account' do
      let!(:account1) { create(:account) }
      let(:user) { account1.owner }
      let!(:account2) { create(:account, user_id: user.id) }

      it 'should return first account' do
        expect(user.first_account).to eq account1
      end
    end

    describe '#no_account?' do
      let(:user) { create(:user) }

      it { expect(user.no_account?).to eq true }

      context 'with account' do
        let(:user) do
          acc = create(:account)
          acc.owner
        end

        it { expect(user.no_account?).to eq false }
      end
    end
  end
end
