require 'rails_helper'

RSpec.describe EmailSubmissionsAudit, type: :model do
  describe '.purge!' do
    let(:finder_double) { double.as_null_object }
    let(:days_ago) { 123.days.ago }

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        'completed_at <= :date', date: days_ago
      ).and_return(finder_double)

      described_class.purge!(days_ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(finder_double)
      expect(finder_double).to receive(:destroy_all)

      described_class.purge!(days_ago)
    end
  end
end
