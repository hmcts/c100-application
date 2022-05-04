require 'rails_helper'

RSpec.describe C100App::SaveApplicationForLater do
  subject { described_class.new(c100_application, user) }

  let(:user) { instance_double(User) }

  describe '#save' do
    context 'for a `nil` c100 application' do
      let(:c100_application) { nil }

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'does not send any email' do
        expect(NotifyMailer).not_to receive(:application_saved_confirmation)
        subject.save
      end

      it 'email_sent? is false' do
        subject.save
        expect(subject.email_sent?).to eq(false)
      end
    end

    context 'for a c100 application already saved before (belongs to a user)' do
      let(:c100_application) { instance_double(C100Application, user: user) }

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'does not trigger any update in the c100 application' do
        expect(c100_application).not_to receive(:update)
        subject.save
      end

      it 'does not send any email' do
        expect(NotifyMailer).not_to receive(:application_saved_confirmation)
        subject.save
      end

      it 'email_sent? is false' do
        subject.save
        expect(subject.email_sent?).to eq(false)
      end
    end

    context 'for a never saved before c100 application' do
      let(:c100_application) { instance_double(C100Application, user: nil, update: true) }
      let(:mailer_double) { double.as_null_object }

      before do
        allow(
          NotifyMailer
        ).to receive(:application_saved_confirmation).with(
          c100_application
        ).and_return(mailer_double)
      end

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'links the c100 application to the user' do
        expect(c100_application).to receive(:update).with(user: user)
        subject.save
      end

      it 'sends a confirmation email' do
        subject.save
        expect(mailer_double).to have_received(:deliver_later)
      end

      it 'email_sent? is true' do
        subject.save
        expect(subject.email_sent?).to eq(true)
      end

      context 'if the update fails' do
        let(:c100_application) { instance_double(C100Application, user: nil, update: false) }

        it 'does not send any email' do
          expect(NotifyMailer).not_to receive(:application_saved_confirmation)
          subject.save
        end

        it 'email_sent? is false' do
          subject.save
          expect(subject.email_sent?).to eq(false)
        end
      end
    end
  end
end
