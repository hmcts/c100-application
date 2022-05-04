module Steps
  module AttendingCourt
    class LanguageForm < BaseForm
      include ArrangementsCheckBoxesForm
      setup_attributes_for LanguageHelp, attribute_name: :language_options

      # any other attributes
      attribute :language_interpreter_details, String
      attribute :sign_language_interpreter_details, String
      attribute :welsh_language_details, String

      validates_presence_of :language_interpreter_details,
                            if: :language_interpreter?

      validates_presence_of :sign_language_interpreter_details,
                            if: :sign_language_interpreter?

      validates_presence_of :welsh_language_details,
                            if: :welsh_language?

      private

      def additional_attributes_map
        {
          language_interpreter_details: (language_interpreter_details if language_interpreter?),
          sign_language_interpreter_details: (sign_language_interpreter_details if sign_language_interpreter?),
          welsh_language_details: (welsh_language_details if welsh_language?),
        }
      end
    end
  end
end
