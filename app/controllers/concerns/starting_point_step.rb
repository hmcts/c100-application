module StartingPointStep
  extend ActiveSupport::Concern

  included do
    before_action :save_case_for_later, if: :user_signed_in?, only: [:update]
  end

  private

  def current_c100_application
    # Only the step including this concern should create a tribunal case
    # if there isn't one in the session - because it's the first
    super || initialize_c100_application(intent: intent)
  end

  def update_navigation_stack
    # The step including this concern will reset the navigation stack
    # before re-initialising it in StepController#update_navigation_stack
    current_c100_application.navigation_stack = []
    super
  end

  def save_case_for_later
    TaxTribs::SaveCaseForLater.new(current_c100_application, current_user).save
  end
end
