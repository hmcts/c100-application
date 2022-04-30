module Steps
  module SafetyQuestions
    class AddressConfidentialityController < Steps::SafetyQuestionsStepController
      def edit
        @form_object = AddressConfidentialityForm.new(
          c100_application: current_c100_application,
          address_confidentiality: current_c100_application.address_confidentiality
        )
      end

      def update
        update_and_advance(AddressConfidentialityForm)
      end
    end
  end
end
