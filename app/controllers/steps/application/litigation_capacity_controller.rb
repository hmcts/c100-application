module Steps
  module Application
    class LitigationCapacityController < Steps::ApplicationStepController
      def edit
        @form_object = LitigationCapacityForm.new(
          c100_application: current_c100_application,
          reduced_litigation_capacity: current_c100_application.reduced_litigation_capacity
        )
      end

      def update
        update_and_advance(LitigationCapacityForm, as: :litigation_capacity)
      end
    end
  end
end
