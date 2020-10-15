class WorkflowsController < ApplicationController
  before_action :authenticate_user!

  def index
    @workflows = current_account.workflows
  end

  def new
    @workflow = current_account.workflows.new(type: 'nr')
  end

  def create
    @workflow = current_account.workflows.new(workflow_params)

    if @workflow.save
      @workflow.reload.process_webhook!(webhooks_donation_given_url(host: 'https://05c2452f17a5.ngrok.io'))
      redirect_to workflows_path, notice: 'Workflow was successfully created.'
    else
      render :new
    end
  end

  private

  def workflow_params
    params.require(:workflow).permit(:source_id, :target_id, :source_type, :target_type,
                                     :name, :is_active, donor_tags: [], recurring_donor_tags: [])
  end
end
