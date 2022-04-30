module Summary
  module Sections
    class MiamExemptions < BaseSectionPresenter
      def name
        :miam_exemptions
      end

      def show_header?
        false
      end

      def answers
        return [
          Separator.not_applicable
        ] if exemptions.empty?

        [
          Partial.new(:miam_exemptions, exemptions),
        ]
      end

      private

      def exemptions
        @_exemptions ||= MiamExemptionsPresenter.new(
          c100.miam_exemption
        ).exemptions
      end
    end
  end
end
