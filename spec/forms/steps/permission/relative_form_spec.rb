require 'spec_helper'

RSpec.describe Steps::Permission::RelativeForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :relative
end
