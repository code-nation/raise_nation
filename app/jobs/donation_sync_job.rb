class DonationSyncJob < ApplicationJob
  queue_as :workflow
  sidekiq_options retry: 3

  def perform(workflow_id, donation_id)
    workflow = Workflow.find(workflow_id)
    donation = workflow.donations.find(donation_id)

    workflow.sync_donation!(donation)
  end
end
