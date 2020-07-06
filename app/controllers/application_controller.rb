class ApplicationController < ActionController::Base
  layout :layout_by_resource
  helper_method :current_account

  private

  def current_account
    @current_account ||= current_user.all_accounts.select{|account| account.id == session[:current_account_id].to_i }&.first || current_user.first_account
    session[:current_account_id] = @current_account.id
    @current_account
  end

  def layout_by_resource
    if devise_controller?
      "auth"
    else
      "application"
    end
  end
end
