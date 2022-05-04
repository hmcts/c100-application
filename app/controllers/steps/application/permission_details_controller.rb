module Steps
  module Application
    class PermissionDetailsController < Steps::ApplicationStepController
      def edit
        @form_object = PermissionDetailsForm.new(
          c100_application: current_c100_application,
          permission_details: current_c100_application.permission_details
        )
      end

      def update
        update_and_advance(PermissionDetailsForm)
      end
    end
  end
end
