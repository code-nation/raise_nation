class WorkflowsController < ApplicationController
  before_action :authenticate_user!

  def index
    @workflows = current_account.workflows
  end

  def new
    @workflow = current_account.workflows.new(type: 'nr')
  end

  def create
  end
end
