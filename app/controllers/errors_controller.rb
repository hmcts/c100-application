class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :check_c100_application_presence, only: [
    :application_screening, :application_completed, :payment_error
  ]

  def invalid_session
    respond_with_status(:ok)
  end

  def not_found
    respond_with_status(:not_found)
  end

  def application_not_found
    respond_with_status(:not_found)
  end

  def application_screening
    respond_with_status(:unprocessable_entity)
  end

  def application_completed
    respond_with_status(:unprocessable_entity)
  end

  def payment_error
    respond_with_status(:unprocessable_entity)
  end

  def unhandled
    respond_with_status(:internal_server_error)
  end

  private

  def respond_with_status(status)
    respond_to do |format|
      format.html { render status: status }
      format.all  { head status }
    end
  end
end
