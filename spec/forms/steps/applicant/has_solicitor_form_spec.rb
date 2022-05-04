require 'spec_helper'

RSpec.describe Steps::Applicant::HasSolicitorForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :has_solicitor,
                  reset_when_no: [:solicitor, :payment_type]
end
