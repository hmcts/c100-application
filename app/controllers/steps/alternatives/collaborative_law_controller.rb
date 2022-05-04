module Steps
  module Alternatives
    class CollaborativeLawController < Steps::AlternativesStepController
      def edit
        @form_object = CollaborativeLawForm.build(current_c100_application)
      end

      def update
        update_and_advance(CollaborativeLawForm, as: :collaborative_law)
      end
    end
  end
end
