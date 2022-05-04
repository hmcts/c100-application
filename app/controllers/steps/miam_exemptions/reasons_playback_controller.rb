module Steps
  module MiamExemptions
    class ReasonsPlaybackController < Steps::MiamExemptionsStepController
      def show
        @presenter = MiamExemptionsPresenter.new(
          current_c100_application.miam_exemption
        )
      end
    end
  end
end
