require 'rails_helper'

RSpec.describe C100App::NotifyCallback do
  let(:payload) do
    {
      id: 'id',
      to: 'test@example.com',
      reference: 'reference',
      status: 'status',
      created_at: 'created_at',
      completed_at: 'completed_at',
      sent_at: 'sent_at',
    }
  end

  describe '.new' do
    it 'ensures indifferent access of the payload attributes' do
      expect(HashWithIndifferentAccess).to receive(:new).with(payload).and_return({})
      described_class.new(payload)
    end
  end

  describe '#process!' do
    subject { described_class.new(payload) }

    context 'there is no reference attribute' do
      let(:payload) { super().except(:reference) }

      it 'does not create a record for this payload' do
        expect(EmailSubmissionsAudit).not_to receive(:create!)
        subject.process!
      end

      it 'does not raise an exception' do
        expect { subject.process! }.not_to raise_error
      end
    end

    context 'reference is blank' do
      let(:payload) { super().merge(reference: '') }

      it 'does not create a record for this payload' do
        expect(EmailSubmissionsAudit).not_to receive(:create!)
        subject.process!
      end

      it 'does not raise an exception' do
        expect { subject.process! }.not_to raise_error
      end
    end

    context 'there is a reference' do
      before do
        allow(BCrypt::Password).to receive(:create).with('test@example.com').and_return('**hashed**')
      end

      it 'creates a record for this payload, hashing secure attributes' do
        expect(
          EmailSubmissionsAudit
        ).to receive(:create!).with(
          id: 'id',
          to: '**hashed**',
          reference: 'reference',
          status: 'status',
          created_at: 'created_at',
          completed_at: 'completed_at',
          sent_at: 'sent_at',
        )

        subject.process!
      end
    end

    context 'there are unknown attributes in the payload' do
      let(:payload) { super().merge(notification_type: 'email', foobar: 'yes') }

      it 'creates a record for the payload, filtering out the unknown attributes' do
        expect(
          EmailSubmissionsAudit
        ).to receive(:create!).with(
          hash_excluding(:notification_type, :foobar)
        )

        subject.process!
      end
    end
  end
end
