require 'rails_helper'

RSpec.describe Donation, type: :model do
  it { should belong_to(:workflow) }
  it { should belong_to(:account) }
  it { should belong_to(:donation_source) }
  it { should validate_presence_of(:webhook_data) }
end
