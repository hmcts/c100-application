module C100App
  class OtherChildrenDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :add_another_name
        edit(:names)
      when :names_finished
        edit(:personal_details, id: next_record_id)
      when :personal_details
        after_personal_details
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_personal_details
      if next_record_id
        edit(:personal_details, id: next_record_id)
      else
        edit('/steps/applicant/names')
      end
    end

    def next_record_id
      super(c100_application.other_child_ids)
    end
  end
end
