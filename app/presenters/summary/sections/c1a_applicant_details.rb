module Summary
  module Sections
    class C1aApplicantDetails < BaseSectionPresenter
      def name
        :c1a_applicant_details
      end

      def show_header?
        false
      end

      # rubocop:disable Metrics/AbcSize
      def answers
        return [] if applicant.nil?

        [
          FreeTextAnswer.new(:c1a_full_name, applicant.full_name),
          Answer.new(:person_sex, applicant.gender),
          Answer.new(:c1a_person_type, :applicant), # Always going to be `applicant` in our digital form
          Partial.row_blank_space,
          Separator.new(:contact_details),
          FreeTextAnswer.new(:person_email, applicant.email),
          FreeTextAnswer.new(:person_home_phone, applicant.home_phone),
          FreeTextAnswer.new(:person_mobile_phone, applicant.mobile_phone),
          Answer.new(:person_voicemail_consent, applicant.voicemail_consent),
          Partial.row_blank_space,
          Answer.new(:c1a_address_confidentiality, c100.address_confidentiality, default: GenericYesNo::NO),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def applicant
        @_applicant ||= record_collection.first
      end

      def record_collection
        C8CollectionProxy.new(c100, c100.applicants)
      end
    end
  end
end
