module C100App
  class OpeningDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :children_postcode
        check_if_court_is_valid
      when :research_consent
        edit(:consent_order)
      when :consent_order
        after_consent_order
      when :child_protection_cases
        after_child_protection_cases
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def children_postcode
      step_params.fetch(:children_postcode)
    end

    def check_if_court_is_valid
      court = CourtPostcodeChecker.new.court_for(children_postcode)

      if court
        c100_application.update!(court: court)

        if show_research_consent?
          edit(:research_consent)
        else
          edit(:consent_order)
        end
      else
        show(:no_court_found)
      end
    # `CourtPostcodeChecker` and `Court` already log any potential exceptions
    rescue StandardError
      show(:error_but_continue)
    end

    def after_consent_order
      if question(:consent_order).yes?
        show(:consent_order_sought)
      else
        edit(:child_protection_cases)
      end
    end

    def after_child_protection_cases
      # If we know is a consent order, then it does not matter the answer
      # to this question, we bypass MIAM (jump to safety questions)
      return show('/steps/safety_questions/start') if question(:consent_order).yes?

      if question(:child_protection_cases).yes?
        show(:child_protection_info)
      else
        edit('/steps/miam/acknowledgement')
      end
    end

    def show_research_consent?
      ResearchSampler.candidate?(
        c100_application, Rails.configuration.x.opening.research_consent_weight
      )
    end
  end
end
