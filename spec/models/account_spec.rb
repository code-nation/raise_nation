require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should belong_to(:owner).class_name('User').with_foreign_key(:user_id).inverse_of(:owned_accounts) }
  it { should have_many(:account_users) }
  it { should have_many(:users) }
end
