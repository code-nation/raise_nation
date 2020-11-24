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
    resp.dig('webhook').dig('id')
  end

  def sync_donation!(donation)
    person_id = sync_donor_data!(donation)['person']['id']
    sync_donation_data!(donation, person_id)
  end

  def sync_donor_data!(donation)
    donor_data = donation.donor.donor_data

    donor_payload = {
      person: {
        email: donor_data.dig('user').dig('email'),
        phone: donor_data.dig('user').dig('phoneNumber'),
        first_name: donor_data.dig('user').dig('firstName'),
        last_name: donor_data.dig('user').dig('lastName')
      }
    }

    nb_client.call(:people, :push, donor_payload)
  end

  def sync_donation_data!(donation, person_id)
    return if donation.synced_at.present?

    donation_payload = {
      donation: {
        amount_in_cents: donation.amount_cents,
        payment_type_name: 'Cash',
        donor_id: person_id
      }
    }

    return unless nb_client.call(:donations, :create, donation_payload)

    donation.update(synced_at: DateTime.now)
  end

  alias_attribute :name, :slug
end
