module Settings
  class UpdateCurrentAccountController < ApplicationController
    before_action :authenticate_user!

    def update
      session[:current_account_id] = current_user.accounts.find_by(id: params[:id]).id
      redirect_to root_path
    end
  end
end
