module Settings
  class UpdateCurrentAccountController < ApplicationController
    before_action :authenticate_user!

    def update
      set_current_account_id(params[:id])
      redirect_to request.referer, notice: 'Change account successful.'
    end
  end
end
