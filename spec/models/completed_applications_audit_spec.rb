require 'rails_helper'

RSpec.describe CompletedApplicationsAudit, type: :model do
  let(:court) { instance_double(Court, name: 'Test Court') }

  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0),
      completed_at: Time.at(100),
      submission_type: 'online',
    )
  }

  before do
    allow(c100_application).to receive(:court).and_return(court)
  end

  describe 'db table name' do
    it { expect(described_class.table_name).to eq('completed_applications_audit') }
  end

  describe 'db table primary key' do
    it { expect(described_class.primary_key).to eq('reference_code') }
  end

  describe '.log!' do
    # Metadata tested separately in the `AuditHelper` spec
    let(:audit_helper) { instance_double(AuditHelper, metadata: { foo: 'bar' }) }

    before do
      allow(AuditHelper).to receive(:new).with(c100_application).and_return(audit_helper)
    end

    it 'creates a record with the expected information' do
      expect(
        described_class
      ).to receive(:create).with(
        started_at: Time.at(0),
        completed_at: Time.at(100),
        reference_code: '1970/01/449362AF',
        submission_type: 'online',
        court: 'Test Court',
        metadata: { foo: 'bar' },
      )

      described_class.log!(c100_application)
    end

    context 'when the record already exists' do
      before do
        allow(described_class).to receive(:create).and_raise(ActiveRecord::RecordNotUnique, 'not unique!')
      end

      it 'rescues and log the exception but does not blow up' do
        expect(Rails.logger).to receive(:warn).with('not unique!')

        expect {
          described_class.log!(c100_application)
        }.not_to raise_error
      end
    end
  end

  describe '#c100_application' do
    let(:reference_code) { '1970/01/449362AF' }

    before do
      allow(subject).to receive(:reference_code).and_return(reference_code)
      allow(C100Application).to receive(:find_by_reference_code).with(reference_code).and_return(c100_application)
    end

    it 'returns the corresponding C100 application if still in the database' do
      expect(subject.c100_application).to eq(c100_application)
    end
  end
end
