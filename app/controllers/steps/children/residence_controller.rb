module Steps
  module Children
    class ResidenceController < Steps::ChildrenStepController
      def edit
        @form_object = ResidenceForm.build(
          residence_record, c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(
          ResidenceForm,
          record: residence_record,
          as: :residence
        )
      end

      private

      def residence_record
        current_record.child_residence || current_record.build_child_residence
      end
    end
  end
end
