require 'rails_helper'

RSpec.describe RaiselyCampaign, type: :model do
  subject { build(:raisely_campaign) }

  it { should belong_to(:account) }

  it { should validate_presence_of(:campaign_uuid) }
  it { should validate_presence_of(:api_key) }
  it { should validate_uniqueness_of(:campaign_uuid) }

  describe '#api_key_truncated' do
    let(:campaign) { create(:raisely_campaign) }
    let(:result) { campaign.api_key_truncated }

    it { expect(result).to match(/XXX/) }
  end
end
