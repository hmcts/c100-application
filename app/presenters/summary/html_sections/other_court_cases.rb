module Summary
  module HtmlSections
    class OtherCourtCases < Sections::BaseSectionPresenter
      def name
        :other_court_cases
      end

      def answers
        [
          Answer.new(
            :has_other_court_cases,
            c100.children_previous_proceedings,
            change_path: edit_steps_application_previous_proceedings_path
          ),
          AnswersGroup.new(
            :other_court_cases_details,
            other_court_cases_details,
            change_path: edit_steps_application_court_proceedings_path
          ),
        ].select(&:show?)
      end

      private

      def other_court_cases_details
        return [] if court_proceeding.nil?

        [
          FreeTextAnswer.new(:court_proceeding_children_names,   court_proceeding.children_names),
          FreeTextAnswer.new(:court_proceeding_court_name,       court_proceeding.court_name),
          FreeTextAnswer.new(:court_proceeding_case_number,      court_proceeding.case_number),
          FreeTextAnswer.new(:court_proceeding_proceedings_date, court_proceeding.proceedings_date),
          FreeTextAnswer.new(:court_proceeding_cafcass_details,  court_proceeding.cafcass_details),
          FreeTextAnswer.new(:court_proceeding_order_types,      court_proceeding.order_types),
          FreeTextAnswer.new(:court_proceeding_previous_details, court_proceeding.previous_details),
        ]
      end

      def court_proceeding
        @_court_proceeding ||= c100.court_proceeding
      end
    end
  end
end
