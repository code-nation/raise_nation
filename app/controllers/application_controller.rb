class ApplicationController < ActionController::Base
  layout :layout_by_resource
  helper_method :current_account
  before_action :validate_account_presence!, if: -> { user_signed_in? && !devise_controller? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  def validate_account_presence!
    return unless current_user.no_account?

    redirect_to new_account_path, notice: 'In order to continue you need to create an account first.'
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  def current_account
    @current_account ||= current_user.accounts.find_by(id: session[:current_account_id]) || current_user.first_account
    session[:current_account_id] = @current_account&.id
    @current_account
  end

  def layout_by_resource
    if devise_controller?
      'auth'
    else
      'application'
    end
  end
end
