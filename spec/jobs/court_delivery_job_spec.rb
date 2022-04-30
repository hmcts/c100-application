require 'rails_helper'

RSpec.describe CourtDeliveryJob, type: :job do
  let(:c100_application) { instance_double(C100Application) }
  let(:queue) { double.as_null_object }

  describe '#perform' do
    it 'calls the `CourtOnlineSubmission` service to process the submission' do
      expect(C100App::CourtOnlineSubmission).to receive(:new).with(
        c100_application
      ).and_return(queue)

      expect(queue).to receive(:process)

      CourtDeliveryJob.perform_now(c100_application)
    end
  end
end
