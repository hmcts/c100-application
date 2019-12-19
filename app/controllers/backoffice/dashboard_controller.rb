module Backoffice
  class DashboardController < Backoffice::ApplicationController
    include Auth0Secured

    def index
      @report = CompletedApplicationsAudit.unscoped.order(completed_at: :desc).limit(50)
    end

    def lookup
      @reference_code = params[:reference_code]
      @report = CompletedApplicationsAudit.where(reference_code: @reference_code)

      audit!(
        action: :application_lookup,
        details: { reference_code: @reference_code, found: @report.size }
      )
    end
  end
end
