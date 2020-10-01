require 'uri'
require 'net/http'
require 'openssl'

class RaiselyCampaign < ApplicationRecord
  belongs_to :account

  validates :campaign_uuid, presence: true
  validates :api_key, presence: true
  validates :campaign_uuid, uniqueness: true, if: -> { campaign_uuid.present? }

  attr_accessor :token

  WEBHOOK_API_URL = 'https://api.raisely.com/v3/webhooks'.freeze

  def api_key_truncated
    api_key.truncate(20, omission: 'XXX')
  end

  def create_webhook(webhook_url)
    body = {
      data: {
        url: webhook_url,
        events: ["donation.created"],
        campaignUuid: campaign_uuid
      }
    }.to_json

    resp = Faraday.post(RaiselyCampaign::WEBHOOK_API_URL) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
      req.body = body
    end

    JSON.parse(resp.body).dig("data").dig("uuid")
  end
end
