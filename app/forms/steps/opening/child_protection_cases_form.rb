module Steps
  module Opening
    class ChildProtectionCasesForm < BaseForm
      include SingleQuestionForm

      # Child emergency proceedings are automatically exempt from going to MIAM and thus,
      # if for whatever reason the user entered any MIAM details, we should
      # preemptively reset them if they enable (answer YES) child_protection_cases.
      #
      yes_no_attribute :child_protection_cases, reset_when_yes: [
        :miam_acknowledgement,
        :miam_attended,
        :miam_mediator_exemption,
        :miam_exemption_claim,
        :miam_certification,
        Steps::Miam::CertificationDateForm,
        Steps::Miam::CertificationDetailsForm,
      ]
    end
  end
end
