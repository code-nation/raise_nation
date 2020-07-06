class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
  has_many :owned_accounts, class_name: "Account", foreign_key: :user_id, inverse_of: :owner, dependent: :restrict_with_error

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def first_account
    all_accounts.first
  end

  def all_accounts
    (accounts + owned_accounts).uniq
  end
end
