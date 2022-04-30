module Steps
  module Opening
    class ResearchConsentForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :research_consent, reset_when_no: [:research_consent_email]

      attribute :research_consent_email, NormalisedEmail

      validates_presence_of :research_consent_email, if: -> { research_consent&.yes? }
      validates :research_consent_email, email: true, allow_blank: true, if: -> { research_consent&.yes? }
    end
  end
end
