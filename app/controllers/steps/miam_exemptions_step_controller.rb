module Steps
  class MiamExemptionsStepController < StepController
    private

    def decision_tree_class
      C100App::MiamExemptionsDecisionTree
    end
  end
end
