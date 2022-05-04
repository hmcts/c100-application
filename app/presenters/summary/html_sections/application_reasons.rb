module Summary
  module HtmlSections
    class ApplicationReasons < Sections::BaseSectionPresenter
      def name
        :application_reasons
      end

      def answers
        [
          Answer.new(
            :permission_sought,
            c100.permission_sought,
            change_path: edit_steps_application_permission_sought_path
          ),
          FreeTextAnswer.new(
            :permission_details,
            c100.permission_details,
            change_path: edit_steps_application_permission_details_path
          ),
          FreeTextAnswer.new(
            :application_details,
            c100.application_details,
            change_path: edit_steps_application_details_path
          ),
        ].select(&:show?)
      end
    end
  end
end
