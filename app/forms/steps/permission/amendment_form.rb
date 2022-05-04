module Steps
  module Permission
    class AmendmentForm < QuestionForm
      yes_no_attribute :amendment,
                       reset_when_yes: [
                         :time_order,
                         :living_arrangement,
                         :consent,
                         :family,
                         :local_authority,
                         :relative
                       ]
    end
  end
end
