module Summary
  module HtmlSections
    class SafetyContact < Sections::BaseSectionPresenter
      def name
        :safety_contact
      end

      def answers
        [
          Answer.new(:concerns_contact_type, c100.concerns_contact_type,
                     change_path: edit_steps_abuse_concerns_contact_path),

          Answer.new(:concerns_contact_other, c100.concerns_contact_other,
                     change_path: edit_steps_abuse_concerns_contact_path),
        ].select(&:show?)
      end
    end
  end
end
