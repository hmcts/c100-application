module Steps
  class PetitionStepController < StepController
    private

    def decision_tree_class
      C100App::PetitionDecisionTree
    end
  end
end
