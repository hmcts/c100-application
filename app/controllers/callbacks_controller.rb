class CallbacksController < BareApplicationController
  before_action :authenticate

  respond_to :json

  def notify
    C100App::NotifyCallback.new(payload).process!
    head 200
  end

  private

  # For now we only have a service (Notify) using callbacks, so we don't
  # need to parametrise this method, as we only need one ENV variable.
  #
  def authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, ENV['GOVUK_NOTIFY_BEARER_TOKEN'])
    end
  end

  def payload
    params.permit(callback: {}).fetch(:callback)
  end
end
