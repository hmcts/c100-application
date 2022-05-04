# Intercept any email potentially sent to court in local or test environments.
# This will avoid courts inadvertently receiving test, not real, applications.
#
if %w(development test).include?(Rails.env) || ENV['DEV_TOOLS_ENABLED'].present?
  require_relative '../../lib/court_email_interceptor'
  ActionMailer::Base.register_interceptor(CourtEmailInterceptor)
end
