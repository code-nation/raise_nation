class Account < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: :user_id, inverse_of: :owned_accounts#, optional: true
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users

  validates :organisation_name, presence: true, uniqueness: true

  after_create :create_join_record!

  private

  def create_join_record!
    owner.accounts << self
  end
end
