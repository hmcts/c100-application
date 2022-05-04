module Backoffice
  class AuditController < Backoffice::ApplicationController
    include Auth0Secured

    AUDIT_TIME_PERIOD ||= 30.days

    def index
      @report = BackofficeAuditRecord.where(
        'created_at >= :date', date: Time.current - AUDIT_TIME_PERIOD
      ).order(created_at: :desc)
    end
  end
end
