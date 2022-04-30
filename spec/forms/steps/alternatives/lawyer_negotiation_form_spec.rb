require 'spec_helper'

RSpec.describe Steps::Alternatives::LawyerNegotiationForm do
  it_behaves_like 'a yes-no question form', attribute_name: :alternative_lawyer_negotiation
end
