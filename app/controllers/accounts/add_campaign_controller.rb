module Accounts
  class AddCampaignController < ApplicationController
    before_action :authenticate_user!
    before_action :load_account

    def new
      @campaign = @account.raisely_campaigns.new
      render layout: false
    end

    def create
      @campaign = @account.raisely_campaigns.new(campaign_params)

      if @campaign.save
        redirect_to @account, notice: 'Campaign successfully created'
      else
        redirect_to @account, alert: @campaign.errors.full_messages.join("\n")
      end
    end

    private

    def campaign_params
      params.require(:raisely_campaign).permit(:campaign_uuid, :api_key)
    end

    def load_account
      @account = current_user.accounts.find(params[:account_id])
    end
  end
end
