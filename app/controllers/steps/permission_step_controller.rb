module Steps
  class PermissionStepController < CrudStepController
    private

    def decision_tree_class
      C100App::PermissionDecisionTree
    end

    def question_name
      params.require(:question_name)
    end

    def current_record
      @_current_record ||= record_collection.find_by!(
        id: params.require(:relationship_id)
      )
    end

    def record_collection
      @_record_collection ||= current_c100_application.relationships
    end
  end
end
