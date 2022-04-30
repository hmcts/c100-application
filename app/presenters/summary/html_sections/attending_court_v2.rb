module Summary
  module HtmlSections
    class AttendingCourtV2 < Sections::BaseSectionPresenter
      def name
        :attending_court
      end

      def show?
        arrangement.present? && super
      end

      def answers
        [
          intermediary,
          language_interpreter,
          special_arrangements,
          special_assistance,
        ].flatten.select(&:show?)
      end

      private

      def arrangement
        @_arrangement ||= c100.court_arrangement
      end

      def intermediary
        AnswersGroup.new(
          :intermediary,
          [
            Answer.new(:intermediary_help, arrangement.intermediary_help),
            FreeTextAnswer.new(:intermediary_help_details, arrangement.intermediary_help_details),
          ],
          change_path: edit_steps_attending_court_intermediary_path
        )
      end

      # Note: we convert the booleans in the `Answer` object with `to_s`, so `true` and `false`
      # are both true for `#present?` as we want to show this question even if it is `false`
      # i.e. checkbox was not selected. If `language_options` is `nil`, it means the user didn't
      # yet reach this step and only in that case we skip this block.
      #
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def language_interpreter
        # Do not show this block in CYA if the user didn't yet reach this step
        # (we know because the array will be `nil` in that case).
        return [] if arrangement.language_options.nil?

        AnswersGroup.new(
          :language_interpreter,
          [
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
          ],
          change_path: edit_steps_attending_court_language_path
        )
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def special_arrangements
        # Do not show this block in CYA if the user didn't yet reach this step
        # (we know because the array will be `nil` in that case).
        return [] if arrangement.special_arrangements.nil?

        AnswersGroup.new(
          :special_arrangements,
          [
            MultiAnswer.new(:special_arrangements, arrangement.special_arrangements, show: true),
            FreeTextAnswer.new(:special_arrangements_details, arrangement.special_arrangements_details),
          ],
          change_path: edit_steps_attending_court_special_arrangements_path
        )
      end

      def special_assistance
        # Do not show this block in CYA if the user didn't yet reach this step
        # (we know because the array will be `nil` in that case).
        return [] if arrangement.special_assistance.nil?

        AnswersGroup.new(
          :special_assistance,
          [
            MultiAnswer.new(:special_assistance, arrangement.special_assistance, show: true),
            FreeTextAnswer.new(:special_assistance_details, arrangement.special_assistance_details),
          ],
          change_path: edit_steps_attending_court_special_assistance_path
        )
      end
    end
  end
end
