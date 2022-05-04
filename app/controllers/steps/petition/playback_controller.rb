module Steps
  module Petition
    class PlaybackController < Steps::PetitionStepController
      def show
        @petition = PetitionPresenter.new(
          current_c100_application
        )
        @next_step_path = next_step_path
      end

      private

      def next_step_path
        if current_c100_application.has_safety_concerns?
          edit_steps_petition_protection_path
        else
          edit_steps_alternatives_court_path
        end
      end
    end
  end
end
