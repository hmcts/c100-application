module Steps
  module Miam
    class AttendedForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :miam_attended,
                       reset_when_yes: [
                         :miam_mediator_exemption,
                         :miam_exemption_claim,
                         :miam_exemption,
                       ],
                       reset_when_no: [
                         :miam_certification,
                         Steps::Miam::CertificationDateForm,
                         Steps::Miam::CertificationDetailsForm,
                       ]
    end
  end
end
