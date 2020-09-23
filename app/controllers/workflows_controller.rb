class WorkflowsController < ApplicationController
  before_action :authenticate_user!

  def index
    @workflows = current_account.workflows
  end

  def new
    @workflow = current_account.workflows.new(type: 'nr')
  end

  def create
    @workflow = current_account.workflows.create!(workflow_params)
  end

  private

  def workflow_params
    params.require(:workflow).permit(:source_id, :target_id, :source_type, :target_type, :name)
  end
end
