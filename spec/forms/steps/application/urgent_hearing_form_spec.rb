require 'spec_helper'

RSpec.describe Steps::Application::UrgentHearingForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :urgent_hearing,
                  reset_when_no: [
                    :urgent_hearing_details,
                    :urgent_hearing_when,
                    :urgent_hearing_short_notice,
                    :urgent_hearing_short_notice_details,
                  ]
end
