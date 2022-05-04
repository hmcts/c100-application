require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::DomesticAbuseForm do
  it_behaves_like 'a yes-no question form', attribute_name: :domestic_abuse
end
