class NationsController < ApplicationController
  before_action :load_nation_and_check_owner

  def connect
    redirect_to @nation.nb_auth_client.auth_code.authorize_url(redirect_uri: oauth_nations_url(nation_id: params[:id]))
  end

  def oauth
    if params[:code].present? && @nation.present?
      api_token = @nation.nb_api_token(params[:code], oauth_nations_url(nation_id: params[:nation_id]))
      account = @nation.account
      @nation.update(token: api_token)

      redirect_to account, notice: "Your nation was connected successfully"
    else
      redirect_to account, alert: "Something went wrong when connecting your nation."
    end
  end

  private

  def load_nation_and_check_owner
    @nation = Nation.find(params[:id] || params[:nation_id])
    unless @nation.account&.owner == current_user
      redirect_to @nation.account, alert: 'You can\'t connect a Nation under this account.'
    end
  end
end
