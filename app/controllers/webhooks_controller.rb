class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def donation_given
    head :no_content
  end

  private

  def donation_params
    params.require(:payload).require(:donation).permit!
  end
end
