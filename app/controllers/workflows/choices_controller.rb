module Workflows
  class ChoicesController < ApplicationController
    before_action :authenticate_user!

    def index
      model_klass_name = Workflow::CHOICES_WORKFLOW_HASH[params[:workflow_type]][params[:kind]]
      query_attr = Module.const_get(model_klass_name).query_attr

      render json: {
        results: current_account.send(model_klass_name.pluralize.underscore)
          .where("#{query_attr} LIKE ?", "%#{params[:q]}%").map do |item|
          {
            id: item.id,
            text: item.send(query_attr)
          }
        end
      }
    end
  end
end
