module Steps
  module Permission
    class ParentalResponsibilityForm < QuestionForm
      yes_no_attribute :parental_responsibility,
                       reset_when_yes: [
                         :living_order,
                         :amendment,
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
