module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Form < BaseForm
      include SingleQuestionForm

      yes_no_attribute :<%= step_name.underscore %>
    end
  end
end
