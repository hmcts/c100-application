module Steps
  module Miam
    class CertificationForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :miam_certification, reset_when_no: [
        Steps::Miam::CertificationDateForm,
        Steps::Miam::CertificationDetailsForm,
      ]
    end
  end
end
