class Nation < ApplicationRecord
  include NationSync
  include CampaignNameWithTypeConcern

  belongs_to :account

  validates :slug, presence: true
  validates :slug, uniqueness: true, if: -> { slug.present? }

  DONATION_SUCCEEDED = 'donation_succeeded'.freeze

  def self.query_attr
    'slug'
  end

  def url
    "https://#{slug}.nationbuilder.com"
  end

  def create_webhook(webhook_url)
    webhook_payload = {
      webhook: {
        version: 4,
        url: webhook_url,
        event: Nation::DONATION_SUCCEEDED
      }
    }
    resp = nb_client.call(:webhooks, :create, webhook_payload)
    resp.dig('webhook', 'id')
  end

  def sync_donation!(donation)
    person_id = sync_donor_data!(donation)['person']['id']
    sync_donation_data!(donation, person_id)
  end

  def sync_donor_data!(donation)
    donor = donation.donor
    donor_data = donor.donor_data
    tags = if donation.frequency_one_off?
             donor.donor_tags
           elsif donation.frequency_recurring?
             donor.recurring_donor_tags
           end

    donor_payload = {
      person: {
        email: donor_data.dig('user', 'email'),
        phone: donor_data.dig('user', 'phoneNumber'),
        first_name: donor_data.dig('user', 'firstName'),
        last_name: donor_data.dig('user', 'lastName'),
        tags: tags
      }
    }

    resp = nb_client.call(:people, :push, donor_payload)
    donor.update(
      synced_external_id: resp['person']['id'],
      synced_data: resp
    )
    resp
  end

  def sync_donation_data!(donation, person_id)
    return if donation.synced?
    return if donation.succeeded_at.nil?
    return if donation.payment_type_name.nil?

    donation_payload = {
      donation: {
        amount_in_cents: donation.amount_cents,
        payment_type_name: donation.payment_type_name,
        donor_id: person_id,
        tracking_code_slug: donation.tracking_code_slug,
        succeeded_at: donation.succeeded_at
      }
    }

    data = nb_client.call(:donations, :create, donation_payload)

    return unless data

    donation.update(
      synced_at: DateTime.now,
      synced_data: data['donation'],
      synced_external_id: data['donation']['id']
    )
  end

  alias_attribute :name, :slug
end
