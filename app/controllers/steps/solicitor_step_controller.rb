module Steps
  class SolicitorStepController < StepController
    private

    def decision_tree_class
      C100App::SolicitorDecisionTree
    end
  end
end
