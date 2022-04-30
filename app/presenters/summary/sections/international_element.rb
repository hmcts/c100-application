module Summary
  module Sections
    class InternationalElement < BaseSectionPresenter
      def name
        :international_element
      end

      def show_header?
        false
      end

      def answers
        [
          Answer.new(:international_resident, c100.international_resident, default: GenericYesNo::NO),
          FreeTextAnswer.new(:international_resident_details, c100.international_resident_details),
          Answer.new(:international_jurisdiction, c100.international_jurisdiction, default: GenericYesNo::NO),
          FreeTextAnswer.new(:international_jurisdiction_details, c100.international_jurisdiction_details),
          Answer.new(:international_request, c100.international_request, default: GenericYesNo::NO),
          FreeTextAnswer.new(:international_request_details, c100.international_request_details)
        ].select(&:show?)
      end

      private

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
