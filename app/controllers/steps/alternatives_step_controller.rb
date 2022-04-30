module Steps
  class AlternativesStepController < StepController
    private

    def decision_tree_class
      C100App::AlternativesDecisionTree
    end
  end
end
