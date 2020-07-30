class Nation < ApplicationRecord
  include NationSync

  belongs_to :account

  validates :slug, presence: true
  validates :slug, uniqueness: true, if: -> { slug.present? }
end
