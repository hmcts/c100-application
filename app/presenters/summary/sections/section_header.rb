module Summary
  module Sections
    class SectionHeader < BaseSectionPresenter
      def to_partial_path
        'steps/completion/shared/section_header'
      end

      def show?
        true
      end
    end
  end
end
