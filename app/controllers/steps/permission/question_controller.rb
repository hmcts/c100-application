module Steps
  module Permission
    class QuestionController < Steps::PermissionStepController
      def edit
        @form_object = question_form_class.build(
          current_record, c100_application: current_c100_application,
        )
      end

      def update
        update_and_advance(
          question_form_class,
          record: current_record,
        )
      end

      private

      # As long as we follow the convention for naming form objects, we will
      # end up, as an example, for a question named `parental_responsibility`
      # with the class `Steps::Permission::ParentalResponsibilityForm`
      #
      def question_form_class
        form_class = [question_name.classify, 'Form'].join
        namespace  = self.class.name.deconstantize

        [namespace, form_class].join('::').constantize
      end
    end
  end
end
