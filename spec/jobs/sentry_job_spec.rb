require 'rails_helper'

RSpec.describe SentryJob, type: :job do
  let(:event) { double('event') }

  describe '#perform' do
    it 'calls `Raven` to process the exception' do
      expect(Raven).to receive(:send_event).with(event)
      described_class.perform_now(event)
    end
  end
end
