module Steps
  module Application
    class LitigationCapacityForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :reduced_litigation_capacity, reset_when_no: [
        Steps::Application::LitigationCapacityDetailsForm
      ]
    end
  end
end
