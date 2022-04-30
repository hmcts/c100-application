module Steps
  module Opening
    class ResearchConsentController < Steps::OpeningStepController
      def edit
        @form_object = ResearchConsentForm.build(current_c100_application)
      end

      def update
        update_and_advance(ResearchConsentForm)
      end
    end
  end
end
