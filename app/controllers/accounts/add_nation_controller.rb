module Accounts
  class AddNationController < ApplicationController
    before_action :authenticate_user!
    before_action :load_account

    def new
      @nation = @account.nations.new
      render layout: false
    end

    def create
      @nation = @account.nations.new(nation_params)

      if @nation.save
        redirect_to connect_nation_path(id: @nation.id)
      else
        @nation.destroy
        redirect_to @account, alert: @nation.errors.full_messages.join("\n")
      end
    end

    private

    def nation_params
      params.require(:nation).permit(:slug)
    end

    def load_account
      @account = current_user.accounts.find(params[:account_id])
    end
  end
end
