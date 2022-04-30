module Summary
  module HtmlSections
    class MiamRequirement < Sections::BaseSectionPresenter
      def name
        :miam_requirement
      end

      def answers
        [
          Answer.new(:miam_attended, c100.miam_attended,
                     change_path: edit_steps_miam_attended_path),
          Answer.new(:miam_mediator_exemption, c100.miam_mediator_exemption,
                     change_path: edit_steps_miam_mediator_exemption_path),
          Answer.new(:miam_certification, c100.miam_certification,
                     change_path: edit_steps_miam_certification_path),
          Answer.new(:miam_exemption_claim, c100.miam_exemption_claim,
                     change_path: edit_steps_miam_exemption_claim_path),
        ].select(&:show?)
      end
    end
  end
end
