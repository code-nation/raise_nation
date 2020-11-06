class Donor < ApplicationRecord
  has_many :donations, dependent: :destroy

  enum donor_type: { raisely: 0, nationbuilder: 1 }, _prefix: true
end
