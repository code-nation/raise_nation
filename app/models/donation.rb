class Donation < ApplicationRecord
  belongs_to :workflow
  validates :webhook_data, presence: true

  enum frequency: { one_off: 0, recurring: 1 }

  # Moved here since enum should be loaded first
  DEFAULT_CURRENCY = 'USD'.freeze
  RAISELY_DONATION_PROCESSING_STATUSES = {
    'ONCE' => Donation.frequencies['one_off'],
    'RECURRING' => Donation.frequencies['recurring']
  }.freeze

  monetize :amount_cents
end