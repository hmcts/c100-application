module Steps
  module Application
    class PermissionSoughtForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :permission_sought, reset_when_yes: [:permission_details]
    end
  end
end
