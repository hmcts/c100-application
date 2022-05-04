module Steps
  module International
    class JurisdictionController < Steps::InternationalStepController
      def edit
        @form_object = JurisdictionForm.build(current_c100_application)
      end

      def update
        update_and_advance(JurisdictionForm, as: :jurisdiction)
      end
    end
  end
end
