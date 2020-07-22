module Accounts
  class InviteUserController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user_invite

    def create
      if @user_invite.valid?
        @user_invite.send_invite!
        redirect_to request.referer, notice: "Sent invite to #{invitation_params[:email]}"
      else
        redirect_to request.referer, alert: @user_invite.errors.full_messages.join("\n")
      end
    end

    private

    def set_user_invite
      @user_invite = UserInviteForm.new(invitation_params)
    end

    def invitation_params
      params.require(:user_invite_form).permit(:email, :account_id, :inviter_id)
    end
  end
end
