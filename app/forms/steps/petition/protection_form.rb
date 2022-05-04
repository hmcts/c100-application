module Steps
  module Petition
    class ProtectionForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :protection_orders, reset_when_no: [:protection_orders_details]

      attribute :protection_orders_details, String

      validates_presence_of :protection_orders_details, if: -> { protection_orders&.yes? }
    end
  end
end
