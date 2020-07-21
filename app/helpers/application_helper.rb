module ApplicationHelper
  include ActiveLinkToHelper
  include TemplateNavHelper

  DEFAULT_DATE_FORMAT = '%-d %b %Y'.freeze

  def accounts_without_current(limit = 10)
    return Account.none unless current_account

    current_user.accounts.where.not(id: current_account.id).limit(limit)
  end

  def formatted_date(datetime)
    datetime.strftime(DEFAULT_DATE_FORMAT)
  end
end
