module Accounts
  class NationsController < ApplicationController
    include AccountLoadableConcern

    skip_before_action :load_account, only: [:connect, :oauth]
    before_action :load_nation, only: [:connect, :oauth]

    def new
      @nation = @account.nations.new
      render layout: false
    end

    def create
      @nation = @account.nations.new(nation_params)

      if @nation.save
        redirect_to connect_accounts_nation_path(id: @nation.id)
      else
        @nation.destroy
        redirect_to @account, alert: @nation.errors.full_messages.join("\n")
      end
    end

    def connect
      redirect_to @nation.nb_auth_client.auth_code.authorize_url(redirect_uri: oauth_accounts_nations_url(nation_id: params[:id]))
    end

    def oauth
      if params[:code].present? && @nation.present?
        api_token = @nation.nb_api_token(params[:code], oauth_accounts_nations_url(nation_id: params[:nation_id]))
        account = @nation.account
        @nation.update(token: api_token)

        redirect_to account, notice: 'Your nation was connected successfully'
      else
        redirect_to account, alert: 'Something went wrong when connecting your nation.'
      end
    end

    private

    def nation_params
      params.require(:nation).permit(:slug)
    end

    def load_nation
      @nation = Nation.find(params[:id] || params[:nation_id])
    end
  end
end
