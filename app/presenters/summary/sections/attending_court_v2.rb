module Summary
  module Sections
    class AttendingCourtV2 < BaseSectionPresenter
      def name
        :attending_court
      end

      def show_header?
        false
      end

      def show?
        arrangement.present? && super
      end

      def answers
        [
          *intermediary,
          *language_interpreter,
          *special_arrangements,
          *special_assistance,
        ].select(&:show?)
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      def intermediary
        [
          Separator.new(:intermediary),
          Answer.new(:intermediary_help, arrangement.intermediary_help),
          FreeTextAnswer.new(:intermediary_help_details, arrangement.intermediary_help_details),
        ]
      end

      # Note: we convert the booleans in the `Answer` object with `to_s`, so `true` and `false`
      # are both true for `#present?` as we want to show this question even if it is `false`
      # i.e. checkbox was not selected. If `language_options` is `nil`, it means the user didn't
      # yet reach this step and only in that case we skip this block.
      #
      # rubocop:disable Metrics/AbcSize
      def language_interpreter
        [
          Separator.new(:language_assistance),

          Answer.new(
            :language_interpreter,
            arrangement.language_options.include?(LanguageHelp::LANGUAGE_INTERPRETER.to_s).to_s
          ),
          FreeTextAnswer.new(:language_interpreter_details, arrangement.language_interpreter_details),

          Answer.new(
            :sign_language_interpreter,
            arrangement.language_options.include?(LanguageHelp::SIGN_LANGUAGE_INTERPRETER.to_s).to_s
          ),
          FreeTextAnswer.new(:sign_language_interpreter_details, arrangement.sign_language_interpreter_details),

          Answer.new(
            :welsh_language,
            arrangement.language_options.include?(LanguageHelp::WELSH_LANGUAGE.to_s).to_s
          ),
          FreeTextAnswer.new(:welsh_language_details, arrangement.welsh_language_details),
        ]
      end
      # rubocop:enable Metrics/AbcSize

      def special_arrangements
        [
          Separator.new(:special_arrangements),
          MultiAnswer.new(:special_arrangements, arrangement.special_arrangements, show: true),
          FreeTextAnswer.new(:special_arrangements_details, arrangement.special_arrangements_details),
        ]
      end

      def special_assistance
        [
          Separator.new(:special_assistance),
          MultiAnswer.new(:special_assistance, arrangement.special_assistance, show: true),
          FreeTextAnswer.new(:special_assistance_details, arrangement.special_assistance_details),
        ]
      end
    end
  end
end
