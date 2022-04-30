require 'rails_helper'

RSpec.describe C100App::PaymentsFlowControl do
  subject { described_class.new(c100_application) }

  let(:c100_application) {
    C100Application.new(
      submission_type: submission_type,
      payment_type: payment_type,
      status: :in_progress,
    )
  }

  let(:submission_type) { SubmissionType::ONLINE }
  let(:payment_type) { PaymentType::ONLINE }

  let(:payment_intent) { PaymentIntent.new(payment_id: 'xyz123') }

  # Some of these tests will create DB records to be as accurate as possible,
  # so we need to do some manual cleaning to not leave leftovers.
  before { C100Application.destroy_all }
  after  { C100Application.destroy_all }

  before do
    allow_any_instance_of(
      C100Application
    ).to receive(:court).and_return(double.as_null_object)
  end

  describe '#payment_url' do
    before do
      allow(
        PaymentIntent
      ).to receive(:create_or_find_by!).with(
        c100_application_id: c100_application.id
      ).and_return(payment_intent)

      allow(payment_intent).to receive(:reload)
    end

    before do
      # We test the confirmation URL separately
      allow(subject).to receive(:confirmation_url).and_return('confirmation-page')
    end

    context 'when payment is offline' do
      let(:payment_type) { PaymentType::HELP_WITH_FEES }

      it 'skips to confirmation' do
        expect(subject.payment_url).to eq('confirmation-page')
      end
    end

    context 'when payment is online' do
      before do
        allow(payment_intent).to receive(:in_progress?).and_return(in_progress)
      end

      context 'when an attempt already exists' do
        let(:in_progress) { true }

        before do
          allow(
            C100App::OnlinePayments
          ).to receive(:retrieve_payment).with(payment_intent).and_return(
            double(payment_url: 'https://payments.example.com')
          )
        end

        it 'sets `payment_in_progress` status and calls the API to retrieve the payment' do
          expect(c100_application).to receive(:payment_in_progress!)
          expect(subject.payment_url).to eq('https://payments.example.com')
        end
      end

      context 'when no previous attempts were found' do
        let(:in_progress) { false }

        before do
          allow(
            C100App::OnlinePayments
          ).to receive(:create_payment).with(payment_intent).and_return(
            double(payment_url: 'https://payments.example.com')
          )
        end

        it 'sets `payment_in_progress` status and calls the API to create the payment' do
          expect(c100_application).to receive(:payment_in_progress!)
          expect(subject.payment_url).to eq('https://payments.example.com')
        end
      end
    end

    context 'when there is an exception' do
      before do
        allow(subject).to receive(:move_status_to)

        allow(
          C100App::OnlinePayments
        ).to receive(:create_payment).and_raise(ArgumentError.new('boom!'))
      end

      it 'bubbles up as a `PaymentUnexpectedError` exception' do
        expect {
          subject.payment_url
        }.to raise_error(Errors::PaymentUnexpectedError).with_message('boom!')
      end
    end
  end

  describe '#payment_url (race conditions)' do
    let(:payment_create_response) {
      double('Payment', payment_id: 'xyz123', state: { 'status' => 'created', 'finished' => false }, payment_url: 'https://payments.example.com')
    }
    let(:payment_retrieve_response) {
      double('Payment', payment_id: 'xyz123', state: { 'status' => 'created', 'finished' => false }, payment_url: 'https://payments.example.com')
    }

    before do
      c100_application.save!

      # Mock responses from the Pay API
      allow_any_instance_of(
        PaymentsApi::Requests::CreateCardPayment
      ).to receive(:call).and_return(payment_create_response)

      allow_any_instance_of(
        PaymentsApi::Requests::GetCardPayment
      ).to receive(:call).and_return(payment_retrieve_response)
    end

    it 'does not create duplicate payments (race conditions)' do
      expect(payment_create_response).to receive(:payment_url).once
      expect(payment_retrieve_response).to receive(:payment_url).exactly(2).times

      Array.new(3) do
        ActiveRecord::Base.connection_pool.with_connection do
          Thread.new do
            subject.payment_url
          end
        end
      end.each(&:join)
    end
  end

  describe '#next_url' do
    before do
      allow(
        PaymentIntent
      ).to receive(:create_or_find_by!).with(
        c100_application_id: c100_application.id
      ).and_return(payment_intent)

      # We test the confirmation URL separately
      allow(subject).to receive(:confirmation_url).and_return('confirmation-page')

      # We also test this separately
      allow(
        C100App::OnlinePayments
      ).to receive(:retrieve_payment).with(payment_intent).and_return(payment_response)
    end

    let(:payment_response) { double('Payment Response', success?: success) }

    context 'for a success payment status' do
      let(:success) { true }

      it 'continues to confirmation' do
        expect(subject.next_url).to eq('confirmation-page')
      end
    end

    context 'for a failed payment status' do
      let(:success) { false }

      let(:payment_state) { {'code' => 'P0030'} }
      let(:error_to_report) { Errors::PaymentError.new(payment_state) }

      before do
        allow(payment_intent).to receive(:state).and_return(payment_state)
      end

      it 'reports the error and returns the error page' do
        expect(c100_application).to receive(:in_progress!)
        expect(subject.next_url).to eq('/errors/payment_error')
      end
    end

    context 'when there is an exception' do
      let(:success) { false }

      before do
        allow(
          C100App::OnlinePayments
        ).to receive(:retrieve_payment).with(payment_intent).and_raise(ArgumentError.new('boom!'))
      end

      it 'bubbles up as a `PaymentUnexpectedError` exception' do
        expect {
          subject.next_url
        }.to raise_error(Errors::PaymentUnexpectedError).with_message('boom!')
      end
    end
  end

  describe '#confirmation_url' do
    let(:queue) { double.as_null_object }

    before do
      expect(c100_application).to receive(:mark_as_completed!)
    end

    context 'for an online submission' do
      let(:submission_type) { SubmissionType::ONLINE }

      it 'process the application online submission and returns the confirmation page' do
        expect(C100App::OnlineSubmissionQueue).to receive(:new).with(c100_application).and_return(queue)

        expect(queue).to receive(:process)
        expect(subject.confirmation_url).to eq('/steps/completion/confirmation')
      end
    end

    context 'for a print and post submission' do
      let(:submission_type) { SubmissionType::PRINT_AND_POST }

      it 'returns the what next page' do
        expect(queue).not_to receive(:process)
        expect(subject.confirmation_url).to eq('/steps/completion/what_next')
      end
    end
  end
end
