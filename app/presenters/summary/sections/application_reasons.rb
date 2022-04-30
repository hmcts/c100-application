module Summary
  module Sections
    class ApplicationReasons < BaseSectionPresenter
      def name
        :application_reasons
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:permission_sought, c100.permission_sought, default: :not_required),
          FreeTextAnswer.new(:permission_details, c100.permission_details),
          FreeTextAnswer.new(:application_details, c100.application_details),
        ].select(&:show?)
      end
    end
  end
end
