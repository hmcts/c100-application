module C100App
  class AbductionDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :international
        edit(:children_have_passport)
      when :children_have_passport
        after_children_have_passport
      when :passport_details
        edit(:previous_attempt)
      when :previous_attempt
        after_previous_attempt
      when :previous_attempt_details
        edit(:risk_details)
      when :risk_details
        edit('/steps/safety_questions/substance_abuse')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_children_have_passport
      if selected?(:children_have_passport)
        edit(:passport_details)
      else
        edit(:previous_attempt)
      end
    end

    def after_previous_attempt
      if selected?(:previous_attempt)
        edit(:previous_attempt_details)
      else
        edit(:risk_details)
      end
    end
  end
end
