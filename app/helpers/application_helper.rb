module ApplicationHelper
  include ActiveLinkToHelper
  include TemplateNavHelper

  def accounts_without_current(limit = 10)
    return Account.none unless current_account

    current_user.accounts.where.not(id: current_account.id).limit(limit)
  end
end
