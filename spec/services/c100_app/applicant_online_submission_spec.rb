require 'rails_helper'

RSpec.describe C100App::ApplicantOnlineSubmission do
  let(:c100_application) { instance_double(C100Application, email_submission: email_submission, receipt_email: 'applicant@email.com') }
  let(:email_submission) { instance_double(EmailSubmission, update: true) }

  subject { described_class.new(c100_application) }

  describe '#to_address' do
    it { expect(subject.to_address).to eq('applicant@email.com') }
  end

  describe '#process' do
    context '#deliver_email' do
      let(:mailer) { spy('mailer') }

      before do
        allow(NotifySubmissionMailer).to receive(:with).with(
          c100_application: c100_application, documents: {}
        ).and_return(mailer)
      end

      it 'delivers the email to the applicant' do
        expect(
          mailer
        ).to receive(:application_to_user).with(to_address: 'applicant@email.com')

        expect(mailer).to receive(:deliver_now)

        subject.process
      end
    end

    context '#audit_data' do
      before do
        allow(subject).to receive(:generate_pdf).and_return(true)
        allow(subject).to receive(:deliver_email).and_return(true)

        travel_to Time.at(0)
      end

      it 'audits the submission details' do
        expect(email_submission).to receive(:update).with(
          email_copy_to: 'applicant@email.com', user_copy_sent_at: Time.at(0)
        )

        subject.process
      end
    end
  end
end
