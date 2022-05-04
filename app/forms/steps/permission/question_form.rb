module Steps
  module Permission
    class QuestionForm < BaseForm
      include SingleQuestionForm

      # Used for i18n locales as we are reusing the same view
      # Corresponds with the yes-no attribute (there is only one)
      def question_name
        attributes.keys.first
      end

      private

      # Here `record` is a `relationship` record
      # This is used in the `SingleQuestionForm` persist method
      def record_to_persist
        record
      end
    end
  end
end
