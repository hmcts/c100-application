module Steps
  module Applicant
    class ContactDetailsForm < BaseForm
      attribute :email, StrippedString
      attribute :home_phone, StrippedString
      attribute :mobile_phone, StrippedString
      attribute :voicemail_consent, YesNo
      attribute :email_provided, YesNo

      attribute :email_keep_private, YesNo
      attribute :phone_keep_private, YesNo
      attribute :mobile_keep_private, YesNo

      # Note: we validate presence of these fields, but allow the applicant to enter
      # free text in case they do not want to disclose their phone or email address.
      # That is why we do not perform any further validation, other than presence
      # (do not validate the format of the phone or email, etc.)
      #
      validates_inclusion_of :email_provided, in: GenericYesNo.values

      validates :email, email: true, if: proc { |o| validate_email_value?(o) }
      validates_presence_of :mobile_phone
      validates :mobile_phone, phone_number: true

      validates_inclusion_of :voicemail_consent, in: GenericYesNo.values

      validates_inclusion_of :email_keep_private, in: GenericYesNo.values, if: proc { |o|
                                                                                 validate_email_value?(o) && address_confidential?
                                                                               }
      validates_inclusion_of :phone_keep_private, in: GenericYesNo.values, if: proc { |o|
                                                                                 o.home_phone.present? && address_confidential?
                                                                               }
      validates_inclusion_of :mobile_keep_private, in: GenericYesNo.values, if: -> { address_confidential? }

      private

      def attributes_map
        super().tap do |hsh|
          hsh[:email] = nil unless email_provided.yes?
          hsh[:email_keep_private] = nil unless email_provided.yes?
        end
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)
        applicant.update(attributes_map)
      end

      def address_confidential?
        raise C100ApplicationNotFound unless c100_application
        c100_application.address_confidentiality == 'yes'
      end

      def validate_email_value?(o)
        o.email_provided && GenericYesNo.new(o.email_provided).yes?
      end
    end
  end
end
