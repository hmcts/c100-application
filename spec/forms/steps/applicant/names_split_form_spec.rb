require 'spec_helper'

RSpec.describe Steps::Applicant::NamesSplitForm do
  it_behaves_like 'a names split CRUD form', Applicant
end
