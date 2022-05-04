module Steps
  module Respondent
    class HasOtherPartiesController < Steps::RespondentStepController
      def edit
        @form_object = HasOtherPartiesForm.new(
          c100_application: current_c100_application,
          has_other_parties: current_c100_application.has_other_parties
        )
      end

      def update
        update_and_advance(HasOtherPartiesForm)
      end
    end
  end
end
