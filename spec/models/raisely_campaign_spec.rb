require 'rails_helper'

RSpec.describe RaiselyCampaign, type: :model do
  subject { build(:raisely_campaign) }

  it { should belong_to(:account) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:campaign_uuid) }
  it { should validate_presence_of(:api_key) }
  it { should validate_uniqueness_of(:campaign_uuid) }

  context 'Constants' do
    it 'DONATION_CREATED' do
      expect(RaiselyCampaign::DONATION_CREATED).to eq 'donation.created'
    end

    it 'WEBHOOK_API_URL' do
      expect(RaiselyCampaign::WEBHOOK_API_URL).to eq 'https://api.raisely.com/v3/webhooks'
    end
  end

  describe '.query_attr' do
    it { expect(RaiselyCampaign.name).to eq 'name' }
  end

  describe '#api_key_truncated' do
    let(:campaign) { create(:raisely_campaign) }
    let(:result) { campaign.api_key_truncated }

    it { expect(result).to match(/XXX/) }
  end

  describe '#create_webhook' do
    pending
  end
end
