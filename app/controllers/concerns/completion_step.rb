module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :check_application_is_completed
  end

  def show
    @court = current_c100_application.court
    @c100_application = current_c100_application
  end

  private

  def check_application_is_completed
    return if current_c100_application.completed?

    redirect_to steps_opening_warning_path
  end
end
