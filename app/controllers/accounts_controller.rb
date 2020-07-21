class AccountsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :validate_account_presence!

  def index
    @accounts = current_user.accounts.includes(:owner)
  end

  def new
    @account = current_user.owned_accounts.new
  end

  def create
    @account = current_user.owned_accounts.new(account_params)

    if @account.save
      redirect_to root_path, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  private

  def account_params
    params.require(:account).permit(:organisation_name)
  end
end
