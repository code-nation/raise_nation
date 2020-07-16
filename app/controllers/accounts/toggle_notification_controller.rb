module Accounts
  class ToggleNotificationController < ApplicationController
    before_action :authenticate_user!

    def update
      current_user.account_users.find_by(account_id: params[:id]).toggle!(:receive_notifications)
      head :no_content
    end
  end
end
