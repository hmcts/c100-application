module Steps
  module Opening
    class PostcodeController < Steps::OpeningStepController
      include StartingPointStep

      def edit
        @form_object = PostcodeForm.build(current_c100_application)
      end

      def update
        update_and_advance(PostcodeForm)
      end
    end
  end
end
