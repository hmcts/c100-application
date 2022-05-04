module Steps
  class ChildrenStepController < CrudStepController
    private

    def decision_tree_class
      C100App::ChildrenDecisionTree
    end

    def names_form_class
      Children::NamesSplitForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.children
    end
  end
end
