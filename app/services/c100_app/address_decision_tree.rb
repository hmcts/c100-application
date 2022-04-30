module C100App
  class AddressDecisionTree < BaseDecisionTree
    include Rails.application.routes.url_helpers
    include PersonUrlHelper

    def destination
      return next_step if next_step

      case step_name
      when :postcode_lookup
        edit(:results, id: record)
      when :address_selection
        person_url_for(record, step: :address_details)
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
