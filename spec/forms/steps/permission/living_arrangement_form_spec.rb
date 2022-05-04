require 'spec_helper'

RSpec.describe Steps::Permission::LivingArrangementForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :living_arrangement,
                  reset_when_yes: [
                      :consent,
                      :family,
                      :local_authority,
                      :relative
                  ]
end
