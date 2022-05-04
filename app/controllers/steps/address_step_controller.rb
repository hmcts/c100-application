module Steps
  class AddressStepController < CrudStepController
    include PersonUrlHelper

    private

    def decision_tree_class
      C100App::AddressDecisionTree
    end

    def record_collection
      @_record_collection ||= current_c100_application.people
    end
  end
end
