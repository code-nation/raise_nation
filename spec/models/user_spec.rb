require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:account_users) }
  it { should have_many(:accounts) }
  it { should have_many(:owned_accounts).class_name('Account').inverse_of(:owner) }

  context '#methods' do
    describe '#full_name' do
      let(:user) { build(:user) }

      it { expect(user.full_name).to eq([user.first_name, user.last_name].join(' ')) }
    end
  end
end
