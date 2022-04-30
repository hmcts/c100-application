module Steps
  module Permission
    class FamilyForm < QuestionForm
      yes_no_attribute :family,
                       reset_when_yes: [
                         :local_authority,
                         :relative
                       ]
    end
  end
end
