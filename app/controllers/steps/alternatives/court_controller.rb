module Steps
  module Alternatives
    class CourtController < Steps::AlternativesStepController
      def edit
        @form_object = CourtForm.build(current_c100_application)
      end

      def update
        update_and_advance(CourtForm, as: :court_acknowledgement)
      end
    end
  end
end
