module Steps
  class OtherPartyStepController < CrudStepController
    private

    def decision_tree_class
      C100App::OtherPartyDecisionTree
    end

    def names_form_class
      OtherParty::NamesSplitForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.other_parties
    end
  end
end
