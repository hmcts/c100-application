module Steps
  class InternationalStepController < StepController
    private

    def decision_tree_class
      C100App::InternationalDecisionTree
    end
  end
end
