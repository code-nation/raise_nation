class Workflow < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true
  belongs_to :account
  has_many :donations, dependent: :destroy

  DEFAULT_SOURCE_TYPE = 'Nation'.freeze
  DEFAULT_TARGET_TYPE = 'RaiselyCampaign'.freeze

  CHOICES_WORKFLOW_HASH = {
    'nr' => {
      'source' => Nation.name,
      'target' => RaiselyCampaign.name
    },
    'rn' => {
      'source' => RaiselyCampaign.name,
      'target' => Nation.name
    }
  }.freeze

  attr_accessor :type

  before_save :cleanup_tags

  validates :source_id, uniqueness: { scope: [:source_type, :target_id, :target_type] }

  def source_type
    return DEFAULT_SOURCE_TYPE if type.blank?

    case type
    when 'nr'
      DEFAULT_SOURCE_TYPE
    when 'rn'
      DEFAULT_TARGET_TYPE
    end
  end

  def target_type
    return DEFAULT_TARGET_TYPE if type.blank?

    case type
    when 'nr'
      DEFAULT_TARGET_TYPE
    when 'rn'
      DEFAULT_SOURCE_TYPE
    end
  end

  def process_webhook!(url)
    return true if webhook_ref.present?

    webhook_ref = source.create_webhook(url)
    update(webhook_ref: webhook_ref) if webhook_ref.present?
  end

  def generate_raisely_donation!(params)
    donations.create!(
      webhook_data: params,
      succeeded_at: params['createdAt'],
      amount_cents: params['amount'],
      # Currently no way to know the currency from Donation Resource API
      amount_currency: params['currency'],
      frequency: raisely_donation_frequency(params['processing']),
      external_id: params['uuid'],
      donor_external_id: params['user']['uuid']
    )
  end

  def generate_nation_donation!(params)
    donations.create!(
      webhook_data: params,
      succeeded_at: params[:succeeded_at],
      amount_cents: params[:amount_in_cents],
      # Currently no way to know the currency from Donation Resource API
      amount_currency: Donation::DEFAULT_CURRENCY,
      frequency: nation_donation_frequency(params[:recurring_donation_id]),
      external_id: params[:id],
      donor_external_id: params[:donor_id]
    )
  end

  private

  def raisely_donation_frequency(processing_type)
    Donation::RAISELY_DONATION_PROCESSING_STATUSES[
      processing_type
    ]
  end

  def nation_donation_frequency(recurring_donation_id)
    if recurring_donation_id.present?
      Donation.frequencies['recurring']
    else
      Donation.frequencies['one_off']
    end
  end

  def cleanup_tags
    self.donor_tags = donor_tags.select(&:present?)
    self.recurring_donor_tags = recurring_donor_tags.select(&:present?)
  end
end
