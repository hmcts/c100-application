require 'spec_helper'

RSpec.describe Steps::Alternatives::CollaborativeLawForm do
  it_behaves_like 'a yes-no question form', attribute_name: :alternative_collaborative_law
end
