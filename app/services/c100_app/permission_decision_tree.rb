module C100App
  class PermissionDecisionTree < BaseDecisionTree
    # rubocop:disable Metrics/MethodLength
    def destination
      return next_step if next_step

      case step_name
      when :parental_responsibility
        advance_or_exit_journey(next_question: :living_order)
      when :living_order
        advance_or_exit_journey(next_question: :amendment)
      when :amendment
        advance_or_exit_journey(next_question: :time_order)
      when :time_order
        advance_or_exit_journey(next_question: :living_arrangement)
      when :living_arrangement
        advance_or_exit_journey(next_question: :consent)
      when :consent
        advance_or_exit_journey(next_question: :family)
      when :family
        advance_or_exit_journey(next_question: :local_authority)
      when :local_authority
        advance_or_exit_journey(next_question: :relative)
      when :relative
        exit_journey
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    # Exit the questions journey the moment we get a `yes` answer,
    # otherwise we keep asking questions until we reach the end.
    def advance_or_exit_journey(next_question:)
      return exit_journey if question(step_name, record).yes?

      edit(:question, question_name: next_question, relationship_id: record)
    end

    # Get back to the applicants-children relationship loop
    def exit_journey
      ApplicantDecisionTree.new(
        c100_application: c100_application, record: record
      ).children_relationships
    end
  end
end
