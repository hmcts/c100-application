module Steps
  module AbuseConcerns
    class QuestionForm < BaseAbuseForm
      attribute :answer, YesNo

      validates_inclusion_of :answer, in: GenericYesNo.values

      private

      def persist!
        abuse_attributes = { answer: answer }

        # If answer is no, reset all detail attributes for this question
        abuse_attributes.merge!(
          Hash[DetailsForm.attribute_names.zip]
        ) if answer.no?

        super(abuse_attributes)
      end
    end
  end
end
