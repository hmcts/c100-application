module Summary
  module Sections
    class OtherCourtCases < BaseSectionPresenter
      def name
        :other_court_cases
      end

      def show_header?
        false
      end

      # rubocop:disable Metrics/AbcSize
      def answers
        return [Separator.not_applicable] unless court_proceeding.present?

        [
          FreeTextAnswer.new(:court_proceeding_children_names,   court_proceeding.children_names),
          FreeTextAnswer.new(:court_proceeding_court_name,       court_proceeding.court_name),
          FreeTextAnswer.new(:court_proceeding_case_number,      court_proceeding.case_number),
          FreeTextAnswer.new(:court_proceeding_proceedings_date, court_proceeding.proceedings_date),
          FreeTextAnswer.new(:court_proceeding_cafcass_details,  court_proceeding.cafcass_details),
          FreeTextAnswer.new(:court_proceeding_order_types,      court_proceeding.order_types),
          FreeTextAnswer.new(:court_proceeding_previous_details, court_proceeding.previous_details),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def court_proceeding
        @_court_proceeding ||= c100.court_proceeding
      end
    end
  end
end
