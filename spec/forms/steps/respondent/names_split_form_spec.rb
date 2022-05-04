require 'spec_helper'

RSpec.describe Steps::Respondent::NamesSplitForm do
  it_behaves_like 'a names split CRUD form', Respondent
end
