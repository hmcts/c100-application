module Summary
  module HtmlSections
    class SafetyConcerns < Sections::BaseSectionPresenter
      def name
        :safety_concerns
      end

      def answers
        [
          Answer.new(:address_confidentiality, c100.address_confidentiality,
                     change_path: edit_steps_safety_questions_address_confidentiality_path),
          Answer.new(:risk_of_abduction, c100.risk_of_abduction,
                     change_path: edit_steps_safety_questions_risk_of_abduction_path),
          substance_abuse,
          Answer.new(:children_abuse, c100.children_abuse,
                     change_path: edit_steps_safety_questions_children_abuse_path),
          Answer.new(:domestic_abuse, c100.domestic_abuse,
                     change_path: edit_steps_safety_questions_domestic_abuse_path),
          Answer.new(:other_abuse, c100.other_abuse,
                     change_path: edit_steps_safety_questions_other_abuse_path),
        ].select(&:show?)
      end

      private

      def substance_abuse
        AnswersGroup.new(
          :substance_abuse,
          [
            Answer.new(:substance_abuse, c100.substance_abuse),
            FreeTextAnswer.new(:substance_abuse_details, c100.substance_abuse_details),
          ],
          change_path: edit_steps_safety_questions_substance_abuse_path
        )
      end
    end
  end
end
