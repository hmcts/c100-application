module Steps
  class AttendingCourtStepController < StepController
    private

    def decision_tree_class
      C100App::AttendingCourtDecisionTree
    end
  end
end
