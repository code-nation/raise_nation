class Account < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id, inverse_of: :owned_accounts
  has_many :account_users, dependent: :destroy
  has_many :nations, dependent: :destroy
  has_many :users, through: :account_users

  validates :organisation_name, presence: true, uniqueness: true

  after_create :create_join_record!

  def receive_notifications?(user)
    account_users.find_by(user: user)&.receive_notifications?
  end

  def owner?(user)
    owner == user
  end

  private

  def create_join_record!
    owner.accounts << self
  end
end
