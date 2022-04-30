module Summary
  module Sections
    class StatementOfTruth < BaseSectionPresenter
      def name
        :statement_of_truth
      end

      def show_header?
        false
      end

      def answers
        [
          Partial.new(
            :statement_of_truth,
            signee_name: signee_name,
            signee_capacity: signee_capacity,
            is_draft: !c100.completed?,
          ),
        ]
      end

      private

      # We must consider `nil` values, for backward compatibility and also because
      # for quick tests we might bypass and render the PDF with details missing.
      #
      def signee_name
        c100.declaration_signee || '<name not entered>'
      end

      def signee_capacity
        c100.declaration_signee_capacity || UserType::APPLICANT
      end
    end
  end
end
