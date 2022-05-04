module Summary
  module Sections
    class PermissionQuestions < BaseSectionPresenter
      def name
        :permission_questions
      end

      def answers
        affirmative_permission_questions
      end

      private

      # Only loop through relationships that entered the non-parents journey,
      # i.e. those having at least the first of those attributes as not `nil`.
      #
      # This saves us from having to iterate through all the relationships, as
      # many of those will be respondents, other parties, or other children.
      #
      def affirmative_permission_questions
        permission_relationships.map do |relationship|
          permission_attributes.map do |attr|
            answer = relationship.try!(attr)

            next if answer.eql?(GenericYesNo::NO.to_s)

            # Break the loop and return the first `yes` answer found
            break Answer.new(
              "child_permission_#{attr}", answer,
              i18n_opts: { applicant_name: relationship.person.full_name, child_name: relationship.minor.full_name }
            )
          end
        end.flatten.compact
      end

      def permission_relationships
        @_permission_relationships ||= c100.relationships.with_permission_data
      end

      def permission_attributes
        Relationship::PERMISSION_ATTRIBUTES
      end
    end
  end
end
