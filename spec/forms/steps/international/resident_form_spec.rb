require 'spec_helper'

RSpec.describe Steps::International::ResidentForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :international_resident,
                  linked_attribute: :international_resident_details,
                  reset_when_no:   [:international_resident_details]
end
