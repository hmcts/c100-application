require 'spec_helper'

RSpec.describe Steps::Petition::ProtectionForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :protection_orders,
                  linked_attribute: :protection_orders_details,
                  reset_when_no:   [:protection_orders_details]
end
