require 'spec_helper'

RSpec.describe Steps::Permission::FamilyForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :family,
                  reset_when_yes: [
                      :local_authority,
                      :relative
                  ]
end
