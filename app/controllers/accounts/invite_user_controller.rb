module Accounts
  class InviteUserController < ApplicationController
    before_action :authenticate_user!

    def create
      user_invite = UserInviteForm.new(invitation_params)

      if user_invite.valid?
        redirect_to request.referrer, notice: "Sent invite to #{invitation_params[:email]}"
      else
        redirect_to request.referrer, alert: user_invite.errors.full_messages.join("\n")
      end
    end

    private

    def invitation_params
      params.require(:user_invite_form).permit(:email, :account_id)
    end
  end
end
