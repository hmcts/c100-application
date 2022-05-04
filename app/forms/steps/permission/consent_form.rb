module Steps
  module Permission
    class ConsentForm < QuestionForm
      yes_no_attribute :consent,
                       reset_when_yes: [
                         :family,
                         :local_authority,
                         :relative
                       ]
    end
  end
end
