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

    donor = Donor.find_or_initialize_by(
      donor_type: :nationbuilder,
      donor_external_id: nation_donor_params[:donor_id],
    )

    donor.donor_tags = workflow.donor_tags
    donor.recurring_donor_tags = workflow.recurring_donor_tags
    donor.donor_data = nation_donor_params
    donor.save

    donation = workflow.generate_nation_donation!(nation_donation_params, donor: donor)
    workflow.sync_donation!(donation)
  end

  def process_raisely_donation!
    source = RaiselyCampaign.find_by(campaign_uuid: raisely_campaign_uuid)
    workflow = Workflow.find_by(source: source)

    return if source.nil? || workflow.nil?

    donor = Donor.find_or_initialize_by(
      donor_type: :raisely,
      donor_external_id: raisely_donor_params[:userUuid]
    )
    donor.donor_tags = workflow.donor_tags
    donor.recurring_donor_tags = workflow.recurring_donor_tags
    donor.donor_data = raisely_donor_params
    donor.save

    donation = workflow.generate_raisely_donation!(raisely_donation_params, donor: donor)
    workflow.sync_donation!(donation)
  end

  def raisely_donation_params
    params.require(:data).permit(:source, data: {})[:data]
  end

  def raisely_donor_params
    params.require(:data).permit(data: {})[:data].permit!
  end

  def nation_donor_params
    params.require(:payload).permit(donation: {})[:donation].permit!
  end

  def nation_donation_params
    params.require(:payload).permit(donation: {})[:donation]
  end

  def raisely_campaign_uuid
    params[:data][:source].split(':')[1]
  end
end
