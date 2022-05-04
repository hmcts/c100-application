module Summary
  module HtmlSections
    class BaseAbuseDetails < Sections::BaseSectionPresenter
      # rubocop:disable Metrics/AbcSize
      def answers
        abuses_suffered.map do |abuse|
          [
            Answer.new(:"abuse_#{abuse.kind}", abuse.answer,
                       change_path: edit_steps_abuse_concerns_question_path(subject: abuse.subject, kind: abuse.kind)),

            AnswersGroup.new(
              :abuse_details,
              [
                FreeTextAnswer.new(:abuse_behaviour_description, abuse.behaviour_description),
                FreeTextAnswer.new(:abuse_behaviour_start, abuse.behaviour_start),
                Answer.new(:abuse_behaviour_ongoing, abuse.behaviour_ongoing),
                FreeTextAnswer.new(:abuse_behaviour_stop, abuse.behaviour_stop),
                Answer.new(:abuse_asked_for_help, abuse.asked_for_help),
                FreeTextAnswer.new(:abuse_help_party, abuse.help_party),
                Answer.new(:abuse_help_provided, abuse.help_provided),
                FreeTextAnswer.new(:abuse_help_description, abuse.help_description),
              ],
              change_path: edit_steps_abuse_concerns_details_path(subject: abuse.subject, kind: abuse.kind)
            ),
          ].select(&:show?)
        end.flatten
      end
      # rubocop:enable Metrics/AbcSize

      private

      # Abuses are returned in the same order we ask them (`created_at`)
      def abuses_suffered
        c100.abuse_concerns.where(
          subject: subject,
        )
      end
    end
  end
end
