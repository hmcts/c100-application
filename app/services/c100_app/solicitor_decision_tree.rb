module C100App
  class SolicitorDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :personal_details
        edit(:address_details)
      when :address_details
        edit(:contact_details)
      when :contact_details
        edit('/steps/respondent/names')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
