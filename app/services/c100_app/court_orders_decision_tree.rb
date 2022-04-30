module C100App
  class CourtOrdersDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :has_court_orders
        after_has_court_orders
      when :orders_details
        edit('/steps/abuse_concerns/contact')
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_has_court_orders
      if question(:has_court_orders).yes?
        edit(:details)
      else
        edit('/steps/abuse_concerns/contact')
      end
    end
  end
end
