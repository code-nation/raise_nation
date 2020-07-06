module Settings
  class UpdateCurrentAccountController < ApplicationController
    before_action :authenticate_user!

    def update
      session[:current_account_id] = current_user.all_accounts.select{ |account| account.id == params[:id].to_i }&.first&.id
      redirect_to root_path
    end
  end
end
