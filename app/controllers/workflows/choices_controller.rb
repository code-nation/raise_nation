module Workflows
  class ChoicesController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: {
        results: current_account
          .send(model_klass_name.pluralize.underscore)
          .where("#{query_attr} LIKE ?", "%#{params[:q]}%").map do |item|
            {
              id: item.id,
              text: item.send(query_attr)
            }
          end
      }
    end

    private

    def model_klass_name
      @model_klass_name ||= Workflow::CHOICES_WORKFLOW_HASH[params[:workflow_type]][params[:kind]]
    end

    def query_attr
      @query_attr ||= Module.const_get(model_klass_name).query_attr
    end
  end
end
