class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :owned_accounts, class_name: 'Account', inverse_of: :owner, dependent: :restrict_with_error

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def first_account
    accounts.first
  end

  def has_account?
    accounts.exists?
  end

  def receive_notifications?(account)
    account_users.find_by(account: account)&.receive_notifications?
  end
end
