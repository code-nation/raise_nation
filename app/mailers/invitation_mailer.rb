class InvitationMailer < ApplicationMailer
  def account_user_invitation(user:, inviter_name:, org_name:)
    @user = user
    @raw_invitation_token = user.raw_invitation_token
    @inviter_name = inviter_name
    @org_name = org_name

    mail(to: user.email, subject: 'You got an invitation to a RaiseNation account')
  end
end
