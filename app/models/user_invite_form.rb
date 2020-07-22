class UserInviteForm
  include ActiveModel::Model

  attr_accessor :email, :account_id, :inviter_id

  validate :check_email_user
  validates :email, presence: true
  validates :account_id, presence: true

  def send_invite!
    if user
      add_user_to_account!(user)
    else
      new_user = User.invite!(email: email) do |u|
        u.skip_invitation = true
      end
      add_user_to_account!(new_user)
    end
  end

  def inviter
    @inviter ||= User.find_by(id: inviter_id)
  end

  def user
    @user ||= User.find_by(email: email)
  end

  def account
    @account ||= Account.find_by(id: account_id)
  end

  private

  def add_user_to_account!(user)
    account.account_users.create(user: user)
    InvitationMailer
      .account_user_invitation(
        user: user,
        inviter_name: inviter.full_name,
        org_name: account.organisation_name
      )
      .deliver_now
  end

  def check_email_user
    return true unless account&.users&.find_by(email: email)

    errors.add(:email, 'already have access to this account')
  end
end
