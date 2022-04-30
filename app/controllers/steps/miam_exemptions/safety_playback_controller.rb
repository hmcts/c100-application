module Steps
  module MiamExemptions
    class SafetyPlaybackController < Steps::MiamExemptionsStepController
      def show
        @presenter = SafetyConcernsPresenter.new(
          current_c100_application
        )
      end
    end
  end
end
