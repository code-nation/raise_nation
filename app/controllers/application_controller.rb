class ApplicationController < ActionController::Base
  layout :layout_by_resource
  helper_method :current_account
  before_action :validate_account_presence!

  def validate_account_presence!
    redirect_to new_account_path if current_user.no_account?
  end

  private

  def current_account
    @current_account ||= current_user.accounts.find_by(id: session[:current_account_id]) || current_user.first_account
    session[:current_account_id] = @current_account&.id
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
