module Steps
  class CourtOrdersStepController < StepController
    private

    def decision_tree_class
      C100App::CourtOrdersDecisionTree
    end
  end
end
