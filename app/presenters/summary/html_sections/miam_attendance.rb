module Summary
  module HtmlSections
    class MiamAttendance < Sections::BaseSectionPresenter
      def name
        :miam_attendance
      end

      def answers
        [
          DateAnswer.new(
            :miam_certification_date,
            c100.miam_certification_date,
            change_path: edit_steps_miam_certification_date_path
          ),
          AnswersGroup.new(
            :miam_certification_details,
            miam_certification_details,
            change_path: edit_steps_miam_certification_details_path
          ),
        ].select(&:show?)
      end

      private

      def miam_certification_details
        [
          FreeTextAnswer.new(:miam_certification_number, c100.miam_certification_number),
          FreeTextAnswer.new(:miam_certification_service_name, c100.miam_certification_service_name),
          FreeTextAnswer.new(:miam_certification_sole_trader_name, c100.miam_certification_sole_trader_name),
        ]
      end
    end
  end
end
