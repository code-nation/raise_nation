class User < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :owned_accounts, class_name: "Account", foreign_key: :user_id, inverse_of: :owner, dependent: :restrict_with_error

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
