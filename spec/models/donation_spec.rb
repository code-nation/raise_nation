require 'rails_helper'

RSpec.describe Donation, type: :model do
  it { should belong_to(:workflow) }
  it { should validate_presence_of(:webhook_data) }
  it { should validate_presence_of(:workflow) }
  it { should validate_presence_of(:donation_type) }

  it 'donation types' do
    expect(Donation.donation_types.keys).to eq(['raisely_campaign', 'nation'])
  end
end
