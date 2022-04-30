module C100App
  class InternationalDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :resident
        edit(:jurisdiction)
      when :jurisdiction
        edit(:request)
      when :request
        after_request_step
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def after_request_step
      rules = Permission::ApplicationRules.new(c100_application)

      # Non-parents - permission to apply
      if rules.permission_needed?
        edit('/steps/application/permission_sought')
      else
        rules.reset_permission_details!
        edit('/steps/application/details')
      end
    end
  end
end
