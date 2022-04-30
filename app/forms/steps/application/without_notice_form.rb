module Steps
  module Application
    class WithoutNoticeForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :without_notice, reset_when_no: [
        Steps::Application::WithoutNoticeDetailsForm
      ]
    end
  end
end
