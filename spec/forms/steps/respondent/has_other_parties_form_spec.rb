require 'spec_helper'

RSpec.describe Steps::Respondent::HasOtherPartiesForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :has_other_parties,
                  reset_when_no: [:other_party_ids]
end
