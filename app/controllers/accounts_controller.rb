class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_account, only: [:show]
  skip_before_action :validate_account_presence!

  def show
    @users = @account.users
    @nations = @account.nations
    @campaigns = @account.raisely_campaigns
    @user_invite_form = UserInvitation.new(account_id: @account.id)
  end

  def index
    @accounts = current_user.accounts.includes(:owner)
  end

  def new
    @account = current_user.owned_accounts.new
  end

  def create
    @account = current_user.owned_accounts.new(account_params)

    if @account.save
      update_current_account_id(@account.id)
      redirect_to root_path, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  private

  def load_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:organisation_name)
  end
end
