module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Controller < Steps::<%= task_name.camelize %>StepController
      def show; end
    end
  end
end
