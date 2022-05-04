module Steps
  class SafetyQuestionsStepController < StepController
    private

    def decision_tree_class
      C100App::SafetyQuestionsDecisionTree
    end
  end
end
