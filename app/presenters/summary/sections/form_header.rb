module Summary
  module Sections
    class FormHeader < BaseSectionPresenter
      def to_partial_path
        'steps/completion/shared/form_header'
      end

      def show?
        true
      end
    end
  end
end
