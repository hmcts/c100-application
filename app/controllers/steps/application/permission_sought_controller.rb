module Steps
  module Application
    class PermissionSoughtController < Steps::ApplicationStepController
      def edit
        @form_object = PermissionSoughtForm.new(
          c100_application: current_c100_application,
          permission_sought: current_c100_application.permission_sought
        )
      end

      def update
        update_and_advance(PermissionSoughtForm)
      end
    end
  end
end
