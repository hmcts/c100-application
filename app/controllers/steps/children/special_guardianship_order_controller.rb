module Steps
  module Children
    class SpecialGuardianshipOrderController < Steps::ChildrenStepController
      def edit
        @form_object = SpecialGuardianshipOrderForm.build(
          current_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          SpecialGuardianshipOrderForm,
          record: current_record,
          as: :special_guardianship_order
        )
      end
    end
  end
end
