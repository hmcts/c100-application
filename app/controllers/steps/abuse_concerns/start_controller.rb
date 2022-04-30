module Steps
  module AbuseConcerns
    class StartController < Steps::AbuseConcernsStepController
      def show
        @presenter = SafetyConcernsPresenter.new(
          current_c100_application
        )
      end
    end
  end
end
