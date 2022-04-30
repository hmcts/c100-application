module Steps
  module Opening
    class StartController < Steps::OpeningStepController
      skip_before_action :check_c100_application_presence, :update_navigation_stack
      before_action :existing_application_warning, :reset_c100_application_session

      def show; end
    end
  end
end
