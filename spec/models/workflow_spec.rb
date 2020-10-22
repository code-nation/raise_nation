require 'rails_helper'

RSpec.describe Workflow, type: :model do
  it { should belong_to(:account) }
  it { should belong_to(:source) }
  it { should belong_to(:target) }
  it { should have_many(:donations) }

  context 'Constants' do
    it 'DEFAULT_SOURCE_TYPE' do
      expect(Workflow::DEFAULT_SOURCE_TYPE).to eq 'Nation'
    end

    it 'DEFAULT_TARGET_TYPE' do
      expect(Workflow::DEFAULT_TARGET_TYPE).to eq 'RaiselyCampaign'
    end

    it 'CHOICES_WORKFLOW_HASH' do
      expect(Workflow::CHOICES_WORKFLOW_HASH).to eq(
        {
          'nr' => {
            'source' => 'Nation',
            'target' => 'RaiselyCampaign'
          },
          'rn' => {
            'source' => 'RaiselyCampaign',
            'target' => 'Nation'
          }
        }
      )
    end
  end

  describe '#source_type' do
    let(:type) { 'nr' }
    let(:workflow) do
      workflow = build(:workflow)
      workflow.type = type
      workflow
    end

    it { expect(workflow.source_type).to eq 'Nation' }

    context 'type rn' do
      let(:type) { 'rn' }

      it { expect(workflow.source_type).to eq 'RaiselyCampaign' }
    end

    context 'type nil' do
      let(:type) { nil }

      it { expect(workflow.source_type).to eq 'Nation' }
    end
  end

  describe '#target_type' do
    let(:type) { 'nr' }
    let(:workflow) do
      workflow = build(:workflow)
      workflow.type = type
      workflow
    end

    it { expect(workflow.target_type).to eq 'RaiselyCampaign' }

    context 'type rn' do
      let(:type) { 'rn' }

      it { expect(workflow.target_type).to eq 'Nation' }
    end

    context 'type nil' do
      let(:type) { nil }

      it { expect(workflow.target_type).to eq 'RaiselyCampaign' }
    end
  end

  describe '#save_and_process_webhook!' do
    pending
  end

  describe '#process_webhook!' do
    pending
  end

  describe '#cleanup_tags' do
    pending
  end
end
