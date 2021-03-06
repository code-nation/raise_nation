module Settings
  class UpdateCurrentAccountController < ApplicationController
    before_action :authenticate_user!

    def update
      update_current_account_id(params[:id])
      redirect_to root_path, notice: 'Change account successful.'
    end
  end
end
