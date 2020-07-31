class RaiselyCampaign < ApplicationRecord
  belongs_to :account

  validates :campaign_uuid, presence: true
  validates :api_key, presence: true
  validates :campaign_uuid, uniqueness: true, if: -> { campaign_uuid.present? }

  def api_key_truncated
    api_key.truncate(20, omission: 'XXX')
  end
end
