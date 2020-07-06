module ApplicationHelper
  include ActiveLinkToHelper
  include TemplateNavHelper

  def accounts_without_current(limit = 10)
    current_user.owned_accounts.where.not(id: current_account.id).limit(limit) + 
      current_user.accounts.joins(:account_users).where.not(account_users: { account_id: current_account.id }).limit(limit)
  end
end
