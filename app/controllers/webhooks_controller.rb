class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def donation_given
    process_donation!
    head :no_content
  end

  private

  def process_donation!
    if params[:nation_slug].present?
      process_nation_donation!
    elsif params[:data][:source].present?
      process_raisely_donation!
    end
  end

  def process_nation_donation!
    source = Nation.find_by(slug: params[:nation_slug])
    workflow = Workflow.find_by(source: source)

    return if source.nil? || workflow.nil?

    workflow.generate_nation_donation!(nation_donation_params)
  end

  def process_raisely_donation!
    source = RaiselyCampaign.find_by(campaign_uuid: raisely_campaign_uuid)
    workflow = Workflow.find_by(source: source)

    return if source.nil? || workflow.nil?

    workflow.generate_raisely_donation!(raisely_donation_params)
  end

  def raisely_donation_params
    params.require(:data).permit(:source, data: {})[:data]
  end

  def nation_donation_params
    params.require(:payload).permit(donation: {})[:donation]
  end

  def raisely_campaign_uuid
    params[:data][:source].split(':')[1]
  end
end
