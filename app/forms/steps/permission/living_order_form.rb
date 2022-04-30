module Steps
  module Permission
    class LivingOrderForm < QuestionForm
      yes_no_attribute :living_order,
                       reset_when_yes: [
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
