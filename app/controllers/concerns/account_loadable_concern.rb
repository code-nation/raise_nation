module AccountLoadableConcern
  extend ActiveSupport::Concern

  included do
    before_action :load_account

    private

    def load_account
      @account = current_user.accounts.find(params[:account_id])
    end
  end
end
