module Accounts
  class RaiselyCampaignsController < ApplicationController
    include AccountLoadableConcern

    before_action :load_campaign, only: [:edit, :update]

    def new
      @campaign = @account.raisely_campaigns.new
      render layout: false
    end

    def create
      @campaign = @account.raisely_campaigns.new(new_campaign_params)

      if @campaign.save
        redirect_to @account, notice: 'Campaign successfully created'
      else
        redirect_to @account, alert: @campaign.errors.full_messages.join("\n")
      end
    end

    def edit
      render layout: false
    end

    def update
      if @campaign.update(update_campaign_params)
        redirect_to @account, notice: 'Campaign was successfully updated.'
      else
        redirect_to @account, alert: @campaign.errors.full_messages.join("\n")
      end
    end

    private

    def new_campaign_params
      params.require(:raisely_campaign).permit(:name, :campaign_uuid, :api_key)
    end

    def update_campaign_params
      params.require(:raisely_campaign).permit(:name, :api_key)
    end

    def load_campaign
      @campaign = @account.raisely_campaigns.find(params[:id])
    end
  end
end
