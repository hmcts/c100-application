require 'rails_helper'

RSpec.describe Respondent, type: :model do
  it_behaves_like 'a model with structured first and last names'
  it_behaves_like 'a model with structured address details'
end
