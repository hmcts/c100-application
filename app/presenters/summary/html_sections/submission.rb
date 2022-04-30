module Summary
  module HtmlSections
    class Submission < Sections::BaseSectionPresenter
      def name
        :submission
      end

      def answers
        [
          AnswersGroup.new(
            :submission_type,
            [
              Answer.new(:submission_type, c100.submission_type),
              FreeTextAnswer.new(:submission_receipt_email, c100.receipt_email),
            ],
            change_path: edit_steps_application_submission_path
          )
        ].select(&:show?)
      end
    end
  end
end
