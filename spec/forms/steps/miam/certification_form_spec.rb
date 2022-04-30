require 'spec_helper'

RSpec.describe Steps::Miam::CertificationForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :miam_certification,
                  reset_when_no: [
                    :miam_certification_date,
                    :miam_certification_number,
                    :miam_certification_service_name,
                    :miam_certification_sole_trader_name,
                  ]
end
