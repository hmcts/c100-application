require 'spec_helper'

RSpec.describe Steps::Permission::LocalAuthorityForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :local_authority,
                  reset_when_yes: [
                      :relative,
                  ]
end
