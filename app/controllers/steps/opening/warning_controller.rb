module Steps
  module Opening
    class WarningController < Steps::OpeningStepController
      skip_before_action :update_navigation_stack

      def show; end
    end
  end
end
