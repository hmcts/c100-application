module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Controller < Steps::<%= task_name.camelize %>StepController
      def edit
        @form_object = <%= step_name.camelize %>Form.new(
          c100_application: current_c100_application,
          <%= step_name.underscore  %>: current_c100_application.<%= step_name.underscore %>
        )
      end

      def update
        update_and_advance(<%= step_name.camelize %>Form)
      end
    end
  end
end
