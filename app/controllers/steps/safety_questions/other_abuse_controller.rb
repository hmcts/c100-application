module Steps
  module SafetyQuestions
    class OtherAbuseController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = OtherAbuseForm.new(
          c100_application: current_c100_application,
          other_abuse: current_c100_application.other_abuse
        )
      end

      def update
        update_and_advance(OtherAbuseForm)
      end
    end
  end
end
