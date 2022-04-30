module Steps
  class OtherChildrenStepController < CrudStepController
    private

    def decision_tree_class
      C100App::OtherChildrenDecisionTree
    end

    def names_form_class
      OtherChildren::NamesSplitForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.other_children
    end
  end
end
