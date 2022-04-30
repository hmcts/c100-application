require 'spec_helper'

RSpec.describe Steps::Permission::ParentalResponsibilityForm do
  it_behaves_like 'a permission yes-no question form',
                  attribute_name: :parental_responsibility,
                  reset_when_yes: [
                      :living_order,
                      :amendment,
                      :time_order,
                      :living_arrangement,
                      :consent,
                      :family,
                      :local_authority,
                      :relative
                  ]
end
