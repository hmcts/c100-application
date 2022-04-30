require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::AddressConfidentialityForm do
  it_behaves_like 'a yes-no question form', attribute_name: :address_confidentiality
end
