require 'spec_helper'

RSpec.describe Steps::International::RequestForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :international_request,
                  linked_attribute: :international_request_details,
                  reset_when_no:   [:international_request_details]
end
