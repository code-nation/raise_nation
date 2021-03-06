require 'uri'
require 'net/http'
require 'openssl'

class RaiselyCampaign < ApplicationRecord
  include CampaignNameWithTypeConcern

  belongs_to :account

  validates :name, presence: true
  validates :campaign_uuid, presence: true
  validates :api_key, presence: true
  validates :campaign_uuid, uniqueness: true, if: -> { campaign_uuid.present? }

  DONATION_CREATED = 'donation.created'.freeze
  BASE_API_URL = 'https://api.raisely.com/v3'.freeze
  WEBHOOK_API_URL = "#{BASE_API_URL}/webhooks".freeze

  before_save :set_raisely_slug

  def self.query_attr
    'name'
  end

  def api_key_truncated
    api_key.truncate(20, omission: 'XXX')
  end

  def create_webhook(webhook_url)
    resp = Faraday.post(RaiselyCampaign::WEBHOOK_API_URL) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
      req.body = webhook_payload(webhook_url)
    end

    JSON.parse(resp.body).dig('data').dig('uuid')
  end

  def url
    "https://admin.raisely.com/campaigns/#{slug}"
  end

  private

  def set_raisely_slug
    resp = Faraday.get(RaiselyCampaign::BASE_API_URL + "/campaigns/#{campaign_uuid}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
    end

    self.slug = JSON.parse(resp.body).dig('data').dig('path')
  end

  def webhook_payload(webhook_url)
    {
      data: {
        url: webhook_url,
        events: [RaiselyCampaign::DONATION_CREATED],
        campaignUuid: campaign_uuid
      }
    }.to_json
  end
end
