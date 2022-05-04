require 'spec_helper'

RSpec.describe Steps::Application::WithoutNoticeForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :without_notice,
                  reset_when_no: [
                    :without_notice_details,
                    :without_notice_frustrate,
                    :without_notice_frustrate_details,
                    :without_notice_impossible,
                    :without_notice_impossible_details,
                  ]
end
