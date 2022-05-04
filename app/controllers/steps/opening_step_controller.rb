module Steps
  class OpeningStepController < StepController
    skip_before_action :check_application_not_screening

    private

    def decision_tree_class
      C100App::OpeningDecisionTree
    end

    def in_progress_enough?
      current_c100_application.navigation_stack.size > 2 &&
        %w[screening completed].exclude?(current_c100_application.status)
    end

    def existing_application_warning
      return unless current_c100_application
      return unless in_progress_enough? && !params.key?(:new)

      redirect_to steps_opening_warning_path
    end
  end
end
