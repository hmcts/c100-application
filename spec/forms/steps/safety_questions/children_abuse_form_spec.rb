require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::ChildrenAbuseForm do
  it_behaves_like 'a yes-no question form', attribute_name: :children_abuse
end
