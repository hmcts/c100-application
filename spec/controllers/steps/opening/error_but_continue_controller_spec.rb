require 'rails_helper'

RSpec.describe Steps::Opening::ErrorButContinueController, type: :controller do
  before do
    # We test the healthcheck in `courtfinder_api_spec.rb` and in
    # cucumber tests so this can be mocked to not repeat ourselves.
    allow_any_instance_of(
      C100App::CourtfinderAPI
    ).to receive(:is_ok?).and_return(true)
  end

  it_behaves_like 'a show step controller'
end
