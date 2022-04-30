module Steps
  module Application
    class WithoutNoticeDetailsController < Steps::ApplicationStepController
      def edit
        @form_object = WithoutNoticeDetailsForm.build(current_c100_application)
      end

      def update
        update_and_advance(WithoutNoticeDetailsForm, as: :without_notice_details)
      end
    end
  end
end
