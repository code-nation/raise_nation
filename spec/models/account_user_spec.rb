require 'rails_helper'

RSpec.describe AccountUser, type: :model do
  it { should belong_to(:account) }
  it { should belong_to(:user) }

  it {
    expect(create(:account_user)).to validate_uniqueness_of(:user_id).scoped_to(:account_id)
  }
end
