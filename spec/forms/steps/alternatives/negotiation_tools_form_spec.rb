require 'spec_helper'

RSpec.describe Steps::Alternatives::NegotiationToolsForm do
  it_behaves_like 'a yes-no question form', attribute_name: :alternative_negotiation_tools
end
