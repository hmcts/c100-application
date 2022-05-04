module Steps
  class RespondentStepController < CrudStepController
    private

    def decision_tree_class
      C100App::RespondentDecisionTree
    end

    def names_form_class
      Respondent::NamesSplitForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.respondents
    end
  end
end
