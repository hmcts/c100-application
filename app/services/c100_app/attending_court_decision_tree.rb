module C100App
  class AttendingCourtDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :intermediary
        edit(:language)
      when :language
        edit(:special_arrangements)
      when :special_arrangements
        edit(:special_assistance)
      when :special_assistance
        edit('/steps/application/submission')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
