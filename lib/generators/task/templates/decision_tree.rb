module C100App
  class <%= task_name.camelize %>DecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      # TODO: Put decision logic here
      when :name
        root_path
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
  end
end
