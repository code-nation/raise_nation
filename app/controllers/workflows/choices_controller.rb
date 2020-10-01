module Workflows
  class ChoicesController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: case params[:workflow_type]
      when 'nr'
        case params[:kind]
        when 'source'
          {
            results: current_account.nations.where("slug LIKE ?", "%#{params[:q]}%").map { |item|
              {
                id: item.id,
                text: item.slug
              }
            }
          }
        when 'target'
          {
            results: current_account.raisely_campaigns.where("campaign_uuid LIKE ?", "%#{params[:q]}%").map { |item|
              {
                id: item.id,
                text: item.campaign_uuid
              }
            }
          }
        else
          {
            results: []
          }
        end
      when 'rn'
        case params[:kind]
        when 'source'
          {
            results: current_account.raisely_campaigns.where("campaign_uuid LIKE ?", "%#{params[:q]}%").map { |item|
              {
                id: item.id,
                text: item.campaign_uuid
              }
            }
          }
        when 'target'
          {
            results: current_account.nations.where("slug LIKE ?", "%#{params[:q]}%").map { |item|
              {
                id: item.id,
                text: item.slug
              }
            }
          }
        else
          {
            results: []
          }
        end
      else
        {
          results: []
        }
      end
    end
  end
end
