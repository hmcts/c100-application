module Steps
  module Application
    class WithoutNoticeController < Steps::ApplicationStepController
      def edit
        @form_object = WithoutNoticeForm.new(
          c100_application: current_c100_application,
          without_notice: current_c100_application.without_notice
        )
      end

      def update
        update_and_advance(WithoutNoticeForm)
      end
    end
  end
end
