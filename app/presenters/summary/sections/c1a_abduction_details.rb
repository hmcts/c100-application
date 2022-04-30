module Summary
  module Sections
    class C1aAbductionDetails < BaseSectionPresenter
      def name
        :c1a_abduction_details
      end

      def show_header?
        false
      end

      # rubocop:disable Metrics/AbcSize
      def answers
        return [
          Answer.new(:c1a_abduction_risk, c100.risk_of_abduction)
        ] unless abduction.present?

        [
          Answer.new(:c1a_abduction_risk, c100.risk_of_abduction),
          FreeTextAnswer.new(:c1a_abduction_details, abduction.risk_details),
          Answer.new(:c1a_abduction_previous_attempt, abduction.previous_attempt),
          FreeTextAnswer.new(:c1a_abduction_previous_attempt_details, abduction.previous_attempt_details),
          FreeTextAnswer.new(:c1a_abduction_children_current_location, abduction.current_location),
          Answer.new(:c1a_abduction_passport_office_notified, abduction.passport_office_notified),
          Answer.new(:c1a_abduction_children_multiple_passports, abduction.children_multiple_passports),
          MultiAnswer.new(:c1a_abduction_passport_possession, abduction.passport_possession),
          FreeTextAnswer.new(:c1a_abduction_passport_possession_other, abduction.passport_possession_other_details),
          Answer.new(:c1a_abduction_previous_attempt_agency_involved, abduction.previous_attempt_agency_involved),
          FreeTextAnswer.new(:c1a_abduction_previous_attempt_agency_details, abduction.previous_attempt_agency_details),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def abduction
        @_abduction ||= c100.abduction_detail
      end
    end
  end
end
