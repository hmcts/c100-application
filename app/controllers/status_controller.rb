class StatusController < BareApplicationController
  respond_to :json

  BUILD_ARGS = {
    build_date: ENV['APP_BUILD_DATE'],
    build_tag: ENV['APP_BUILD_TAG'],
    commit_id: ENV['APP_GIT_COMMIT'],
  }.freeze

  # Use the `ping` endpoint for kubernetes probes, and this one
  # for Pingdom or similar monitoring systems. Reason being this
  # endpoint reports external dependencies that can fail, and
  # kubernetes would kill the pods/containers if this happens.
  #
  def index
    check = C100App::Status.new
    status_code = check.success? ? :ok : :internal_server_error

    respond_with(check.response, status: status_code)
  end

  def ping
    respond_with(BUILD_ARGS)
  end
end
