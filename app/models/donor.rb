class Donor < ApplicationRecord
  has_many :donations, dependent: :destroy
  belongs_to :account

  enum donor_type: { raisely: 0, nationbuilder: 1 }, _prefix: true
end
