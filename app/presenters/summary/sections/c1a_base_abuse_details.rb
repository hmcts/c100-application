module Summary
  module Sections
    class C1aBaseAbuseDetails < BaseSectionPresenter
      def answers
        abuses_suffered.map do |abuse|
          [
            Answer.new(:c1a_abuse_type, "#{abuse.subject}.#{abuse.kind}"),
            FreeTextAnswer.new(:c1a_abuse_behaviour_description, abuse.behaviour_description, show: true),
            FreeTextAnswer.new(:c1a_abuse_behaviour_start, abuse.behaviour_start),
            Answer.new(:c1a_abuse_behaviour_ongoing, abuse.behaviour_ongoing),
            FreeTextAnswer.new(:c1a_abuse_behaviour_stop, abuse.behaviour_stop),
            Answer.new(:c1a_abuse_asked_for_help, abuse.asked_for_help),
            FreeTextAnswer.new(:c1a_abuse_help_party, abuse.help_party),
            Answer.new(:c1a_abuse_help_provided, abuse.help_provided),
            FreeTextAnswer.new(:c1a_abuse_help_description, abuse.help_description),
            Partial.row_blank_space,
          ].select(&:show?)
        end.flatten
      end

      private

      # Override in subclasses to filter some of the abuse kinds, if needed
      def filtered_abuses
        []
      end

      # Abuses are returned in the same order we ask them (`created_at`)
      def abuses_suffered
        c100.abuse_concerns.where(
          answer: GenericYesNo::YES,
          subject: subject,
        ).where.not(
          kind: filtered_abuses.map(&:to_s)
        )
      end
    end
  end
end
