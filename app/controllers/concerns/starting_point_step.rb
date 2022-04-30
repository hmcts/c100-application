module StartingPointStep
  extend ActiveSupport::Concern

  private

  def current_c100_application
    # Only the step including this concern should create a C100 application
    # if there isn't one in the session - because it's the first
    super || initialize_c100_application
  end

  def update_navigation_stack
    # The step including this concern will reset the navigation stack
    # before re-initialising it in StepController#update_navigation_stack
    current_c100_application.navigation_stack = []
    super
  end
end
