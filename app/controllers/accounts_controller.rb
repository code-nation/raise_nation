class AccountsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :validate_account_presence!

  def new
    @account = current_user.owned_accounts.new
  end

  def create
    @account = current_user.owned_accounts.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to root_path, notice: 'Account was successfully created.' }
        format.json { redirect_to root_path, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def account_params
    params.require(:account).permit(:organisation_name)
  end
end
