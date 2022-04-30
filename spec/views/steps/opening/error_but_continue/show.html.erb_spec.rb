require 'rails_helper'

RSpec.describe 'steps/opening/error_but_continue/show', type: :view do
  before do
    allow(view).to receive(:step_header)

    assign(
      :courtfinder_ok, courtfinder_ok
    )

    render
  end

  context 'when court tribunal finder is healthy' do
    let(:courtfinder_ok) { true }

    it 'shows the appropriate error message' do
      expect(rendered).to match(/our checker didn’t recognise it/)
    end
  end

  context 'when court tribunal finder is unhealthy' do
    let(:courtfinder_ok) { false }

    it 'shows the appropriate error message' do
      expect(rendered).to match(/trouble connecting to our postcode checker/)
    end
  end
end
