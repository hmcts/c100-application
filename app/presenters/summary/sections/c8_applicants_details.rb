module Summary
  module Sections
    class C8ApplicantsDetails < PeopleDetails
      def name
        :c8_applicants_details
      end

      def show_header?
        true
      end

      def record_collection
        c100.applicants
      end

      # Not using the superclass `PeopleDetails#answers` because, in the case of
      # applicants, most of the information is already disclosed in the C100, and here
      # we just need to show the confidential details. The superclass will show all.
      #
      # modify this to list only the private details
      def answers
        record_collection.map.with_index(1) do |person, index|
          [
            Separator.new("#{name}_index_title", index: index),
            FreeTextAnswer.new(:person_full_name, person.full_name),
            address(person),
            person_email(person),
            person_home_phone(person),
            person_mobile_phone(person),
            Answer.new(:person_voicemail_consent, person.voicemail_consent),
            Partial.row_blank_space,
            residence_history(person),
            Partial.row_blank_space,
          ]
        end.flatten.select(&:show?)
      end

      private

      def residence_history(person)
        value = confidential? && person.residence_keep_private != 'no' ? person.residence_history : nil
        FreeTextAnswer.new(:person_residence_history, value)
      end

      def address(person)
        value = confidential? && person.residence_keep_private != 'no' ? person.full_address : nil
        FreeTextAnswer.new(:person_address, value)
      end

      def person_email(person)
        value = confidential? && person.email_keep_private == 'yes' ? person.email : nil
        FreeTextAnswer.new(:person_email, value)
      end

      def person_home_phone(person)
        value = confidential? && person.phone_keep_private == 'yes' ? person.home_phone : nil
        FreeTextAnswer.new(:person_home_phone, value)
      end

      def person_mobile_phone(person)
        value = confidential? && person.mobile_keep_private == 'yes' ? person.mobile_phone : nil
        FreeTextAnswer.new(:person_mobile_phone, value)
      end

      def confidential?
        c100.address_confidentiality == 'yes'
      end
    end
  end
end
