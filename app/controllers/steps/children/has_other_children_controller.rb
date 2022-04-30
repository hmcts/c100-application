module Steps
  module Children
    class HasOtherChildrenController < Steps::ChildrenStepController
      def edit
        @form_object = HasOtherChildrenForm.new(
          c100_application: current_c100_application,
          has_other_children: current_c100_application.has_other_children
        )
      end

      def update
        update_and_advance(HasOtherChildrenForm)
      end
    end
  end
end
