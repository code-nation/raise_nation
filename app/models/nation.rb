class Nation < ApplicationRecord
  include NationSync

  validates :slug, uniqueness: true, allow_nil: true
end
