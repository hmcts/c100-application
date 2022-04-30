module Summary
  module HtmlSections
    class MiamExemptions < Sections::BaseSectionPresenter
      def name
        :miam_exemptions
      end

      # rubocop:disable Metrics/MethodLength
      def answers
        [
          MultiAnswer.new(
            :miam_exemptions_domestic,
            selection_for(:domestic),
            change_path: edit_steps_miam_exemptions_domestic_path
          ),
          MultiAnswer.new(
            :miam_exemptions_protection,
            selection_for(:protection),
            change_path: edit_steps_miam_exemptions_protection_path
          ),
          MultiAnswer.new(
            :miam_exemptions_urgency,
            selection_for(:urgency),
            change_path: edit_steps_miam_exemptions_urgency_path
          ),
          MultiAnswer.new(
            :miam_exemptions_adr,
            selection_for(:adr),
            change_path: edit_steps_miam_exemptions_adr_path
          ),
          MultiAnswer.new(
            :miam_exemptions_misc,
            selection_for(:misc),
            change_path: edit_steps_miam_exemptions_misc_path
          ),
        ].select(&:show?)
      end
      # rubocop:enable Metrics/MethodLength

      private

      def selection_for(group)
        presenter.selection_for(group, filter: :groups)
      end

      def presenter
        @_presenter ||= MiamExemptionsPresenter.new(c100.miam_exemption)
      end
    end
  end
end
