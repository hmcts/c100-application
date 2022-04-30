require 'spec_helper'

RSpec.describe Steps::Permission::AmendmentForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :amendment,
                  reset_when_yes: [
                      :time_order,
                      :living_arrangement,
                      :consent,
                      :family,
                      :local_authority,
                      :relative
                  ]
end
