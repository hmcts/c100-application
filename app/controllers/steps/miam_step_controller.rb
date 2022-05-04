module Steps
  class MiamStepController < StepController
    private

    def decision_tree_class
      C100App::MiamDecisionTree
    end
  end
end
