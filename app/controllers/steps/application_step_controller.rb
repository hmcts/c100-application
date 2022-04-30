module Steps
  class ApplicationStepController < StepController
    private

    def decision_tree_class
      C100App::ApplicationDecisionTree
    end
  end
end
