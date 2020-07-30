module Accounts
  class RaiselyCampaignsController < ApplicationController
    before_action :load_account
    before_action :load_campaign

    def edit
      render layout: false
    end

    def update
      if @campaign.update(campaign_params)
        redirect_to @account, notice: 'Campaign was successfully updated.'
      else
        redirect_to @account, alert: @campaign.errors.full_messages.join("\n")
      end
    end

    private

    def campaign_params
      params.require(:raisely_campaign).permit(:api_key)
    end

    def load_account
      @account = current_user.accounts.find(params[:account_id])
    end

    def load_campaign
      @campaign = @account.raisely_campaigns.find(params[:id])
    end
  end
end
