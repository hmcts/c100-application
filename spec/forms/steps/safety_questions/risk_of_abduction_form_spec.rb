require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::RiskOfAbductionForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :risk_of_abduction,
                  reset_when_no: [:abduction_detail]
end
