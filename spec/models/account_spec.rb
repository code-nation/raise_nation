require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { create(:account) }

  it { should belong_to(:owner).class_name('User').with_foreign_key(:user_id).inverse_of(:owned_accounts) }
  it { should have_many(:account_users) }
  it { should have_many(:users) }

  it { should validate_presence_of(:organisation_name) }
  it { should validate_uniqueness_of(:organisation_name) }

  describe 'Creation of Join record' do
    let(:account) { build(:account) }

    before(:each) { account.save }

    it "should set the account's owner automatically" do
      expect(account.owner.reload.accounts).to include(account)
    end
  end
end
