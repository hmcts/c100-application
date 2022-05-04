module Backoffice
  class ErrorsController < Backoffice::ApplicationController
    skip_before_action :verify_authenticity_token

    def unhandled
      respond_with_status(:internal_server_error)
    end

    private

    def respond_with_status(status)
      respond_to do |format|
        format.html
        format.all { head status }
      end
    end
  end
end
