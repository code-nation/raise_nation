module Accounts
  class ToggleNotificationController < ApplicationController
    before_action :authenticate_user!

    def update
      account = current_user.account_users.find_by(account_id: params[:id])
      account.toggle(:receive_notifications)
      account.save

      head :no_content
    end
  end
end
