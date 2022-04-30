module Steps
  class AbuseConcernsStepController < StepController
    private

    def decision_tree_class
      C100App::AbuseConcernsDecisionTree
    end
  end
end
