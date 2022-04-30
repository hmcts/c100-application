module Steps
  module Application
    class UrgentHearingForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :urgent_hearing, reset_when_no: [
        Steps::Application::UrgentHearingDetailsForm
      ]
    end
  end
end
