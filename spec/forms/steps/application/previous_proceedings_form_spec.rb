require 'spec_helper'

RSpec.describe Steps::Application::PreviousProceedingsForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :children_previous_proceedings,
                  reset_when_no: [:court_proceeding]
end
