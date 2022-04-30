module Steps
  module SafetyQuestions
    class ChildrenAbuseController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = ChildrenAbuseForm.new(
          c100_application: current_c100_application,
          children_abuse: current_c100_application.children_abuse
        )
      end

      def update
        update_and_advance(ChildrenAbuseForm)
      end
    end
  end
end
