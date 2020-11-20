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
  BASE_API_URL = 'https://api.raisely.com'.freeze
  API_URL_V3 = (BASE_API_URL + '/v3').freeze
  API_URL_V2 = (BASE_API_URL + '/v2').freeze
  WEBHOOK_API_URL = "#{API_URL_V3}/webhooks".freeze

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

  def sync_donor_data!(donation)
    donor_data = donation.donor.donor_data

    url = URI(RaiselyCampaign::API_URL_V3 + "/users?private=false")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = "Bearer #{api_key}"
    request.body = {
      data: {
        email: donor_data['donor']['email'],
        first_name: donor_data['donor']['first_name'],
        last_name: donor_data['donor']['last_name'],
        phone: donor_data['donor']['phone']
      },
      # Sets to true to automatically creates/updates the user based on email
      merge: true
    }.to_json

    http.request(request)
  end

  def sync_donation_data!(donation)
    donor_data = donation.donor.donor_data

    donation_payload = {
      data: {
        # Since donation already been succeeded from NationBuilder
        type: 'OFFLINE',
        amount: donation.amount.to_s,
        currency: donation.amount_currency,
        firstName: donor_data['donor']['first_name'],
        lastName: donor_data['donor']['last_name'],
        email: donor_data['donor']['email'],
        profieUuid: campaign_uuid
      }
    }.to_json

    url = URI(RaiselyCampaign::API_URL_V3 + "/donations")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = "Bearer #{api_key}"
    request.body = donation_payload

    http.request(request)
  end

  private

  def set_raisely_slug
    resp = Faraday.get(RaiselyCampaign::API_URL_V3 + "/campaigns/#{campaign_uuid}") do |req|
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
