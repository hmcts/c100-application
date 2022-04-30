require 'spec_helper'

RSpec.describe Steps::CourtOrders::HasOrdersForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :has_court_orders,
                  reset_when_no: [:court_order]
end
