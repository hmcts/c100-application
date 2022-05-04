module Steps
  module Petition
    class ProtectionController < Steps::PetitionStepController
      def edit
        @form_object = ProtectionForm.build(current_c100_application)
      end

      def update
        update_and_advance(ProtectionForm, as: :protection)
      end
    end
  end
end
