module Steps
  module Application
    class PreviousProceedingsForm < BaseForm
      include SingleQuestionForm

      # The reset will delete the row from the `court_proceedings` table
      yes_no_attribute :children_previous_proceedings, reset_when_no: [:court_proceeding]
    end
  end
end
