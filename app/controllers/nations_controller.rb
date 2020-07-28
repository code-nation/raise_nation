class NationsController < ApplicationController
  def connect
    @nation = Nation.find(params[:id])
    session[:nation_id] = @nation.id
    redirect_to @nation.nb_auth_client.auth_code.authorize_url(redirect_uri: oauth_nations_url)
  end

  def oauth
    @nation = Nation.find_by(id: session[:nation_id])

    if params[:code].present? && @nation.present?
      api_token = @nation.nb_api_token(params[:code], oauth_nations_url)
      @nation.update(token: api_token)

      redirect_to root_path, notice: "Your nation was connected successfully"
    else
      redirect_to root_path, alert: "Something went wrong when connecting your nation."
    end
  end
end
