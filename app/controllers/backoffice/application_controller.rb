module Backoffice
  class ApplicationController < ActionController::Base
    include SecurityHandling

    skip_before_action :check_http_credentials
    layout 'backoffice'

    rescue_from Exception do |exception|
      raise if Rails.application.config.consider_all_requests_local

      Raven.capture_exception(exception)
      redirect_to unhandled_backoffice_errors_path
    end

    private

    def audit!(args)
      BackofficeAuditRecord.log!(
        { author: helpers.admin_name }.merge(args)
      )
    end

    # This is required to get request attributes in to the production logs.
    # See the various lograge configurations in `production.rb`.
    def append_info_to_payload(payload)
      super
      payload[:referrer] = request&.referrer
      payload[:session_id] = request&.session&.id
      payload[:user_agent] = request&.user_agent
    end
  end
end
