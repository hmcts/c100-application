module Summary
  module HtmlSections
    class Abduction < Sections::BaseSectionPresenter
      def name
        :abduction
      end

      def show?
        abduction.present? && super
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def answers
        [
          Answer.new(:abduction_passport_office_notified, abduction.passport_office_notified,
                     change_path: edit_steps_abduction_international_path),
          Answer.new(:abduction_children_have_passport, abduction.children_have_passport,
                     change_path: edit_steps_abduction_children_have_passport_path),
          AnswersGroup.new(
            :abduction_passport_possession,
            [
              Answer.new(:abduction_children_multiple_passports, abduction.children_multiple_passports),
              MultiAnswer.new(:abduction_passport_possession, abduction.passport_possession),
              FreeTextAnswer.new(:abduction_passport_possession_other, abduction.passport_possession_other_details),
            ],
            change_path: edit_steps_abduction_passport_details_path
          ),
          Answer.new(:abduction_previous_attempt, abduction.previous_attempt,
                     change_path: edit_steps_abduction_previous_attempt_path),
          AnswersGroup.new(
            :abduction_previous_attempt,
            [
              FreeTextAnswer.new(:abduction_previous_attempt_details, abduction.previous_attempt_details),
              Answer.new(:abduction_previous_attempt_agency_involved, abduction.previous_attempt_agency_involved),
              FreeTextAnswer.new(:abduction_previous_attempt_agency_details, abduction.previous_attempt_agency_details),
            ],
            change_path: edit_steps_abduction_previous_attempt_details_path
          ),
          AnswersGroup.new(
            :abduction_risk_details,
            [
              FreeTextAnswer.new(:abduction_risk_details, abduction.risk_details),
              FreeTextAnswer.new(:abduction_current_location, abduction.current_location),
            ],
            change_path: edit_steps_abduction_risk_details_path
          )
        ].select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      private

      def abduction
        @_abduction ||= c100.abduction_detail
      end
    end
  end
end
