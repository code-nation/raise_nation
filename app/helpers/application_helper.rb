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

  # Usage:
  # = link_to_modal "Open Modal", some_path, class: "btn btn-primary" %>

  def link_to_modal(title, url, options = {})
    options[:class] = ['modal-link', options[:class]].compact.join(' ')
    if block_given?
      link_to url, options do
        yield
      end
    else
      link_to title, url, options
    end
  end
end
