class Nation < ApplicationRecord
  include NationSync

  belongs_to :account

  validates :slug, presence: true
  validates :slug, uniqueness: true, if: -> { slug.present? }

  DONATION_SUCCEEDED = 'donation_succeeded'.freeze

  def self.query_attr
    'slug'
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
end
