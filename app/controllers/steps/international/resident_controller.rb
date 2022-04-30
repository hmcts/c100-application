module Steps
  module International
    class ResidentController < Steps::InternationalStepController
      def edit
        @form_object = ResidentForm.build(current_c100_application)
      end

      def update
        update_and_advance(ResidentForm, as: :resident)
      end
    end
  end
end
