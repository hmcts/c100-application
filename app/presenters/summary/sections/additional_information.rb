module Summary
  module Sections
    class AdditionalInformation < BaseSectionPresenter
      def name
        :additional_information
      end

      def answers
        [
          Answer.new(:asking_for_permission,         c100.permission_sought,             default: :not_required),
          Answer.new(:urgent_or_without_notice,      urgent_or_without_notice_value,     default: default_value),
          Answer.new(:children_previous_proceedings, c100.children_previous_proceedings, default: default_value),
          Answer.new(:consent_order,                 c100.consent_order,                 default: default_value),
          Answer.new(:international_element_case,    international_element_case_value,   default: default_value),
          Answer.new(:litigation_capacity_case,      c100.reduced_litigation_capacity,   default: default_value),
          Answer.new(:language_assistance,           language_assistance_value,          default: default_value),
        ]
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      def urgent_or_without_notice_value
        [
          c100.urgent_hearing,
          c100.without_notice,
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      def international_element_case_value
        [
          c100.international_resident,
          c100.international_jurisdiction,
          c100.international_request,
        ].detect { |answer| answer.eql?(GenericYesNo::YES.to_s) }
      end

      def language_assistance_value
        return if arrangement.nil?

        GenericYesNo::YES if (LanguageHelp.string_values & arrangement.language_options).any?
      end

      def default_value
        GenericYesNo::NO
      end
    end
  end
end
