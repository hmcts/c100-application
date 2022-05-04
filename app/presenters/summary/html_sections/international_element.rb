module Summary
  module HtmlSections
    class InternationalElement < Sections::BaseSectionPresenter
      def name
        :international_element
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def answers
        [
          AnswersGroup.new(
            :international_resident,
            [
              Answer.new(:international_resident, c100.international_resident),
              FreeTextAnswer.new(:international_resident_details, c100.international_resident_details),
            ],
            change_path: edit_steps_international_resident_path
          ),
          AnswersGroup.new(
            :international_jurisdiction,
            [
              Answer.new(:international_jurisdiction, c100.international_jurisdiction),
              FreeTextAnswer.new(:international_jurisdiction_details, c100.international_jurisdiction_details),
            ],
            change_path: edit_steps_international_jurisdiction_path
          ),
          AnswersGroup.new(
            :international_request,
            [
              Answer.new(:international_request, c100.international_request),
              FreeTextAnswer.new(:international_request_details, c100.international_request_details),
            ],
            change_path: edit_steps_international_request_path
          ),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
