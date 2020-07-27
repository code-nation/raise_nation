class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM = 'noreply@example.com'.freeze

  default from: ENV['SENGRID_DEFAULT_FROM'] || DEFAULT_FROM
  layout 'mailer'
end
