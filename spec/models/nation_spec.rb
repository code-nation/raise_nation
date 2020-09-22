require 'rails_helper'

RSpec.describe Nation, type: :model do
  subject { build(:nation) }

  it { should belong_to(:account) }

  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }

  context 'Constants' do
    it 'DONATION_SUCCEEDED' do
      expect(Nation::DONATION_SUCCEEDED).to eq 'donation_succeeded'
    end
  end

  describe '.query_attr' do
    it { expect(Nation.query_attr).to eq 'slug' }
  end

  describe '#create_webhook' do
    let(:nb_client_stub) { double('NB Client') }
    let(:webhook_url) { 'http://test.lvh.me' }
    let!(:nation) { create(:nation) }
    let(:webhook_id) { SecureRandom.uuid }

    before(:each) do
      allow(nb_client_stub).to receive(:call).and_return(
        {
          'webhook' => {
            'id' => webhook_id
          }
        }
      )
      allow_any_instance_of(Nation).to receive(:nb_client).and_return(nb_client_stub)
    end

    it 'should create webhook' do
      expect(nation.create_webhook(webhook_url)).to eq webhook_id
    end
  end
end
