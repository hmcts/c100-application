module Summary
  module Sections
    class C1aGettingSupport < BaseSectionPresenter
      def name
        :c1a_getting_support
      end

      def show_header?
        false
      end

      def answers
        [
          Partial.page_break,
          Partial.new(:c1a_getting_support),
        ].select(&:show?)
      end
    end
  end
end
