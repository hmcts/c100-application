module Steps
  module International
    class RequestController < Steps::InternationalStepController
      def edit
        @form_object = RequestForm.build(current_c100_application)
      end

      def update
        update_and_advance(RequestForm, as: :request)
      end
    end
  end
end
