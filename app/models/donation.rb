class Donation < ApplicationRecord
  belongs_to :workflow

  validates :webhook_data, presence: true
  validates :workflow, presence: true
  validates :donation_type, presence: true

  enum donation_type: [ RaiselyCampaign.name.underscore.to_sym, Nation.name.underscore.to_sym ]
end
