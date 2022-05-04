module Steps
  class AbductionStepController < StepController
    private

    def decision_tree_class
      C100App::AbductionDecisionTree
    end
  end
end
