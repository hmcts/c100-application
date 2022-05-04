require 'spec_helper'

RSpec.describe Steps::International::JurisdictionForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name:   :international_jurisdiction,
                  linked_attribute: :international_jurisdiction_details,
                  reset_when_no:   [:international_jurisdiction_details]
end
