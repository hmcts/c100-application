module C100App
  class AlternativesDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :court_acknowledgement
        after_court_acknowledgement
      when :negotiation_tools
        edit(:mediation)
      when :mediation
        edit(:lawyer_negotiation)
      when :lawyer_negotiation
        edit(:collaborative_law)
      when :collaborative_law
        start_children_journey
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_court_acknowledgement
      if c100_application.consent_order? || c100_application.has_safety_concerns?
        start_children_journey
      else
        show(:start)
      end
    end

    def start_children_journey
      edit('/steps/children/names')
    end
  end
end
