class UserInviteForm
  include ActiveModel::Model

  attr_accessor :email, :account_id

  validate :check_email_user
  validates :email, presence: true
  validates :account_id, presence: true

  def send_invite!
    true
  end

  private

  def check_email_user
    return true unless Account.find_by(id: account_id)&.users&.find_by(email: email)
    errors.add(:email, 'already have access to this account')
  end
end
