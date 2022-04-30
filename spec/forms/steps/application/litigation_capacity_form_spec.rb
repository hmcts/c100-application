require 'spec_helper'

RSpec.describe Steps::Application::LitigationCapacityForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :reduced_litigation_capacity,
                  reset_when_no: [
                    :participation_capacity_details,
                    :participation_referral_or_assessment_details,
                    :participation_other_factors_details,
                  ]
end
