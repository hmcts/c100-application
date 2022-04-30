require 'spec_helper'

RSpec.describe Steps::Alternatives::MediationForm do
  it_behaves_like 'a yes-no question form', attribute_name: :alternative_mediation
end
