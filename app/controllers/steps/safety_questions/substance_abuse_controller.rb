module Steps
  module SafetyQuestions
    class SubstanceAbuseController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = SubstanceAbuseForm.build(current_c100_application)
      end

      def update
        update_and_advance(SubstanceAbuseForm, as: :substance_abuse)
      end
    end
  end
end
