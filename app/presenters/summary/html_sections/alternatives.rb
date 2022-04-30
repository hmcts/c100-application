module Summary
  module HtmlSections
    class Alternatives < Sections::BaseSectionPresenter
      def name
        :alternatives
      end

      def answers
        [
          Answer.new(:alternative_negotiation_tools,
                     c100.alternative_negotiation_tools,
                     change_path: edit_steps_alternatives_negotiation_tools_path),
          Answer.new(:alternative_mediation,
                     c100.alternative_mediation,
                     change_path: edit_steps_alternatives_mediation_path),
          Answer.new(:alternative_lawyer_negotiation,
                     c100.alternative_lawyer_negotiation,
                     change_path: edit_steps_alternatives_lawyer_negotiation_path),
          Answer.new(:alternative_collaborative_law,
                     c100.alternative_collaborative_law,
                     change_path: edit_steps_alternatives_collaborative_law_path),
        ].select(&:show?)
      end
    end
  end
end
