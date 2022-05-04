require 'spec_helper'

RSpec.describe Steps::Permission::ConsentForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :consent,
                  reset_when_yes: [
                      :family,
                      :local_authority,
                      :relative
                  ]
end
