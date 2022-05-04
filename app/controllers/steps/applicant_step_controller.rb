module Steps
  class ApplicantStepController < CrudStepController
    private

    def decision_tree_class
      C100App::ApplicantDecisionTree
    end

    def names_form_class
      Applicant::NamesSplitForm
    end

    def record_collection
      @_record_collection ||= current_c100_application.applicants
    end
  end
end
