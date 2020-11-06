class Donation < ApplicationRecord
  belongs_to :workflow
  belongs_to :account
  belongs_to :donor
  belongs_to :donation_source, polymorphic: true

  validates :webhook_data, presence: true

  enum frequency: { one_off: 0, recurring: 1 }, _prefix: true

  # Moved here since enum should be loaded first
  DEFAULT_CURRENCY = 'USD'.freeze
  RAISELY_DONATION_PROCESSING_STATUSES = {
    'ONCE' => Donation.frequencies['one_off'],
    'RECURRING' => Donation.frequencies['recurring']
  }.freeze

  monetize :amount_cents

  delegate :source, :target, to: :workflow
  delegate :url, to: :donation_source

  after_create :update_raisely_slug!, if: :raisely_source?

  def raisely_source?
    source.is_a?(RaiselyCampaign)
  end

  def workflow_source_target
    return 'N/A' if !source && !target

    [workflow.source&.name_with_type, workflow.target&.name_with_type].join(' to ')
  end

  def external_donor_url
    case donation_source.class.name
    when Nation.name
      "#{external_base_url}/admin/signups/#{donor_external_id}/edit"
    when RaiselyCampaign.name
      "#{external_base_url.gsub(/campaigns.*/, 'people')}/#{donor_external_id}"
    end
  end

  def external_donation_url
    case donation_source.class.name
    when Nation.name
      "#{external_base_url}/admin/signups/#{donor_external_id}/donations/#{external_id}/edit"
    when RaiselyCampaign.name
      "#{external_base_url}/donations/#{external_id}"
    end
  end

  private

  def update_raisely_slug!
    raisely_slug = webhook_data['profile']['path']

    return if source.slug.eql?(raisely_slug)

    source.update_column('slug', raisely_slug)
  end

  alias external_base_url url
end
