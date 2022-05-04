require 'rails_helper'

RSpec.describe C100Application, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe 'status enum' do
    it 'has the right values' do
      expect(
        described_class.statuses
      ).to eq(
        'screening' => 0,
        'in_progress' => 1,
        'payment_in_progress' => 8,
        'completed' => 10,
      )
    end
  end

  describe 'reminder_status enum' do
    it 'has the right values' do
      expect(
        described_class.reminder_statuses
      ).to eq(
        'first_reminder_sent' => 'first_reminder_sent',
        'last_reminder_sent' => 'last_reminder_sent',
      )
    end
  end

  describe '.purge!' do
    let(:finder_double) { double.as_null_object }

    before do
      travel_to Time.now
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        'c100_applications.created_at <= :date', date: 28.days.ago
      ).and_return(finder_double)

      described_class.purge!(28.days.ago)
    end

    it 'picks records that have not been updated for the past 20 minutes' do
      expect(described_class).to receive(:where).and_return(finder_double)

      expect(finder_double).to receive(:where).with(
        'c100_applications.updated_at <= :date', date: 20.minutes.ago
      ).and_return(finder_double)

      described_class.purge!(28.days.ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(finder_double)
      expect(finder_double).to receive(:destroy_all)

      described_class.purge!(28.days.ago)
    end
  end

  describe '#online_submission?' do
    context 'for `online` values' do
      let(:attributes) { {submission_type: 'online'} }
      it { expect(subject.online_submission?).to eq(true) }
    end

    context 'for other values' do
      let(:attributes) { {submission_type: 'whatever'} }
      it { expect(subject.online_submission?).to eq(false) }
    end
  end

  describe '#online_payment?' do
    context 'for `online` values' do
      let(:attributes) { {payment_type: 'online'} }
      it { expect(subject.online_payment?).to eq(true) }
    end

    context 'for other values' do
      let(:attributes) { {payment_type: 'whatever'} }
      it { expect(subject.online_payment?).to eq(false) }
    end
  end

  describe '#consent_order?' do
    context 'for a `nil` value' do
      let(:attributes) { {consent_order: nil} }
      it { expect(subject.consent_order?).to eq(false) }
    end

    context 'for a `no` value' do
      let(:attributes) { {consent_order: 'no'} }
      it { expect(subject.consent_order?).to eq(false) }
    end

    context 'for a `yes` value' do
      let(:attributes) { {consent_order: 'yes'} }
      it { expect(subject.consent_order?).to eq(true) }
    end
  end

  describe '#child_protection_cases?' do
    context 'for a `nil` value' do
      let(:attributes) { {child_protection_cases: nil} }
      it { expect(subject.child_protection_cases?).to eq(false) }
    end

    context 'for a `no` value' do
      let(:attributes) { {child_protection_cases: 'no'} }
      it { expect(subject.child_protection_cases?).to eq(false) }
    end

    context 'for a `yes` value' do
      let(:attributes) { {child_protection_cases: 'yes'} }
      it { expect(subject.child_protection_cases?).to eq(true) }
    end
  end

  describe '#confidentiality_enabled?' do
    context 'for `yes` values' do
      let(:attributes) { {address_confidentiality: 'yes'} }
      it { expect(subject.confidentiality_enabled?).to eq(true) }
    end

    context 'for `no` values' do
      let(:attributes) { {address_confidentiality: 'no'} }
      it { expect(subject.confidentiality_enabled?).to eq(false) }
    end
  end

  describe '#has_solicitor?' do
    context 'for a `nil` value' do
      let(:attributes) { {has_solicitor: nil} }
      it { expect(subject.has_solicitor?).to eq(false) }
    end

    context 'for a `no` value' do
      let(:attributes) { {has_solicitor: 'no'} }
      it { expect(subject.has_solicitor?).to eq(false) }
    end

    context 'for a `yes` value' do
      let(:attributes) { {has_solicitor: 'yes'} }
      it { expect(subject.has_solicitor?).to eq(true) }
    end
  end

  describe '#has_safety_concerns?' do
    let(:attributes) { {
      domestic_abuse: domestic_abuse,
      risk_of_abduction: 'no',
      children_abuse: 'no',
      substance_abuse: 'no',
      other_abuse: 'no'
    } }

    context 'at least one concern was answered as `YES`' do
      let(:domestic_abuse) { 'yes' }
      it { expect(subject.has_safety_concerns?).to eq(true) }
    end

    context 'there are no concerns' do
      let(:domestic_abuse) { 'no' }
      it { expect(subject.has_safety_concerns?).to eq(false) }

      it 'checks all the neccessary attributes' do
        expect(subject).to receive(:domestic_abuse)
        expect(subject).to receive(:risk_of_abduction)
        expect(subject).to receive(:children_abuse)
        expect(subject).to receive(:substance_abuse)
        expect(subject).to receive(:other_abuse)

        subject.has_safety_concerns?
      end
    end
  end

  describe '#mark_as_completed!' do
    before do
      travel_to Time.at(123)
    end

    it 'marks the application as completed and saves the audit record' do
      expect(
        subject
      ).to receive(:update!).with(
        status: :completed, completed_at: Time.at(123)
      ).and_return(true)

      expect(CompletedApplicationsAudit).to receive(:log!).with(subject)

      subject.mark_as_completed!
    end

    context 'transaction' do
      let(:attributes) { {
        status: :in_progress
      } }

      # In these tests we are testing DB transactions, so we need to persist
      # the record, and cleanup after we are finished with it.
      before do
        subject.save
      end

      after do
        subject.destroy
      end

      it 'reverts the application status to how it was before (rollbacks)' do
        expect(subject.status).to eq('in_progress')
        expect(subject).to receive(:update!).and_call_original

        expect { subject.mark_as_completed! }.to raise_error

        expect(subject.reload.status).to eq('in_progress')
        expect(subject.reload.completed_at).to be_nil
      end
    end
  end
end
