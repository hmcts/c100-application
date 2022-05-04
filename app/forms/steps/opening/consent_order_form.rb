module Steps
  module Opening
    class ConsentOrderForm < BaseForm
      include SingleQuestionForm

      # Consent orders are automatically exempt from going to MIAM and thus,
      # if for whatever reason the user entered any MIAM details, we should
      # preemptively reset them if they enable (answer YES) consent order.
      #
      yes_no_attribute :consent_order, reset_when_yes: [
        :child_protection_cases,
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
