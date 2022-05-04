module C100App
  class SafetyQuestionsDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :address_confidentiality
        edit(:risk_of_abduction)
      when :risk_of_abduction
        after_risk_of_abduction
      when :substance_abuse
        after_substance_abuse
      when :children_abuse
        after_children_abuse
      when :domestic_abuse
        after_domestic_abuse
      when :other_abuse
        after_other_abuse
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_risk_of_abduction
      if question(:risk_of_abduction).yes?
        edit('/steps/abduction/international')
      else
        edit(:substance_abuse)
      end
    end

    def after_substance_abuse
      if question(:substance_abuse).yes? || question(:risk_of_abduction).yes?
        start_abuse_concerns_journey
      else
        edit(:children_abuse)
      end
    end

    def after_children_abuse
      if question(:children_abuse).yes?
        start_abuse_concerns_journey
      else
        edit(:domestic_abuse)
      end
    end

    def after_domestic_abuse
      if question(:domestic_abuse).yes?
        start_abuse_concerns_journey
      else
        edit(:other_abuse)
      end
    end

    def after_other_abuse
      if question(:other_abuse).yes?
        start_abuse_concerns_journey
      else
        edit('/steps/petition/orders')
      end
    end

    def start_abuse_concerns_journey
      show('/steps/abuse_concerns/start')
    end
  end
end
