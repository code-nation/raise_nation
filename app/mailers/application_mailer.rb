class ApplicationMailer < ActionMailer::Base
  default from: ENV['SENGRID_DEFAULT_FROM']
  layout 'mailer'
end
