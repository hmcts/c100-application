module Steps
  module AbuseConcerns
    class QuestionController < BaseAbuseStepController
      def edit
        @form_object = QuestionForm.build(
          current_concern, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(QuestionForm, as: :question)
      end
    end
  end
end
