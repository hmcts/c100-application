require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::OtherAbuseForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :other_abuse,
                  reset_when_no: [
                    :abuse_concern_ids,
                    :has_court_orders,
                    :court_order,
                    :concerns_contact_type,
                    :concerns_contact_other,
                    :protection_orders,
                    :protection_orders_details,
                  ]
end
