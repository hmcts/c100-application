require 'rails_helper'

RSpec.describe C100App::OnlineSubmissionQueue do
  let(:c100_application) { C100Application.create(receipt_email: receipt_email) }
  let(:receipt_email) { nil }

  subject { described_class.new(c100_application) }

  describe '#process' do
    context 'when `email_submission` record already exists' do
      before do
        allow(EmailSubmission).to receive(:create).with(
          c100_application: c100_application
        ).and_raise(ActiveRecord::RecordNotUnique)
      end

      it 'does not process the jobs' do
        expect {
          subject.process
        }.not_to have_enqueued_job
      end
    end

    context 'when `email_submission` record does not exist' do
      before do
        allow(EmailSubmission).to receive(:create).with(
          c100_application: c100_application
        ).and_return(double.as_null_object)
      end

      it 'creates the `email_submission` record' do
        subject.process
      end

      it 'enqueues the court delivery job' do
        expect {
          subject.process
        }.to have_enqueued_job(CourtDeliveryJob).with(c100_application).on_queue('submissions')
      end

      it 'does not enqueue the applicant delivery job' do
        expect {
          subject.process
        }.not_to have_enqueued_job(ApplicantDeliveryJob).with(c100_application).on_queue('submissions')
      end

      context 'when there is a receipt email address' do
        let(:receipt_email) { 'user@example.com' }

        it 'enqueues the applicant delivery job' do
          expect {
            subject.process
          }.to have_enqueued_job(ApplicantDeliveryJob).with(c100_application).on_queue('submissions')
        end
      end
    end
  end
end
