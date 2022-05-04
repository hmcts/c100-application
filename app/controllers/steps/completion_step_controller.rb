module Steps
  class CompletionStepController < StepController
    private

    # TODO: remove the nocov when we start using this decision tree
    # :nocov:
    def decision_tree_class
      C100App::CompletionDecisionTree
    end
    # :nocov:
  end
end
