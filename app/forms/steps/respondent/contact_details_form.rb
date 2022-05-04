module Steps
  module Respondent
    class ContactDetailsForm < BaseForm
      attribute :email, NormalisedEmail
      attribute :email_unknown, Boolean
      attribute :home_phone, StrippedString
      attribute :home_phone_unknown, Boolean
      attribute :mobile_phone, StrippedString
      attribute :mobile_phone_unknown, Boolean

      validates :email, email: true, unless: :email_unknown?
      validates_presence_of  :email, unless: :email_unknown?
      validates_presence_of  :mobile_phone, unless: :mobile_phone_unknown?
      validates :mobile_phone, phone_number: true, unless: :mobile_phone_unknown?
      validates_presence_of  :home_phone, unless: :home_phone_unknown?
      validates :home_phone, phone_number: true, unless: :home_phone_unknown?

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        respondent = c100_application.respondents.find_or_initialize_by(id: record_id)
        respondent.update(
          attributes_map
        )
      end
    end
  end
end
