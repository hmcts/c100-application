require 'rails_helper'

RSpec.describe PaymentsMopUpJob, type: :job do
  before do
    allow(Rails).to receive(:logger).and_return(logger)
  end

  let(:logger) { instance_double(Logger, info: true) }

  describe '.run' do
    let(:c100_application) { instance_double(C100Application, id: '12345') }

    let(:finder_double) { double.as_null_object }
    let(:time_ago) { 15.minutes.ago }

    before do
      allow(C100Application).to receive(:joins).with(:payment_intent).and_return(finder_double)
    end

    it 'finds any pending payment intents' do
      expect(finder_double).to receive(:where).with("payment_intents.state ->> 'finished' = 'false'").and_return(finder_double)
      expect(finder_double).to receive(:where).with("payment_intents.created_at <= :date", date: time_ago).and_return(finder_double)

      expect(finder_double).to receive(:each)
      expect(described_class).not_to receive(:perform_later)

      described_class.run(time_ago)
    end

    it 'enqueues a status refresh for each application found' do
      expect(finder_double).to receive(:each).and_yield(c100_application)
      expect(described_class).to receive(:perform_later).with(c100_application)

      # Mutant killer
      expect(logger).to receive(:info).with(/application 12345/)

      described_class.run(time_ago)
    end
  end

  describe '#perform' do
    let(:c100_application) {
      C100Application.new(
        id: '9b9d6653-a0e5-4685-a145-b7a85aea63fc',
        status: status,
        # this can only be online, we don't have online payments for print and post
        submission_type: 'online',
      )
    }

    let(:payment_intent) { instance_double(PaymentIntent) }
    let(:payment_result) { double(success?: success) }
    let(:status) { :in_progress }

    before do
      allow(c100_application).to receive(:payment_intent).and_return(payment_intent)

      allow(
        C100App::OnlinePayments
      ).to receive(:retrieve_payment).with(payment_intent).and_return(payment_result)
    end

    context 'for a success payment' do
      let(:success) { true }
      let(:queue) { double.as_null_object }

      context 'and application is not already completed' do
        before do
          # Mutant killer
          expect(logger).to receive(:info).twice.with(/application 9b9d6653/)
        end

        it 'marks the application as completed and process the application online submission' do
          expect(c100_application).to receive(:mark_as_completed!)
          expect(C100App::OnlineSubmissionQueue).to receive(:new).with(c100_application).and_return(queue)
          expect(queue).to receive(:process)

          described_class.perform_now(c100_application)
        end
      end

      context 'and application is already completed' do
        let(:status) { :completed }

        before do
          # Mutant killer
          expect(logger).to receive(:info).once.with(/application 9b9d6653/)
        end

        it 'returns without any further actions' do
          expect(c100_application).not_to receive(:mark_as_completed!)
          expect(C100App::OnlineSubmissionQueue).not_to receive(:new)

          described_class.perform_now(c100_application)
        end
      end
    end

    context 'for a failed payment' do
      let(:success) { false }

      it 'does nothing' do
        # Mutant killer
        expect(logger).to receive(:info).once.with(/application 9b9d6653/)

        expect(c100_application).not_to receive(:completed?)
        expect(c100_application).not_to receive(:mark_as_completed!)
        expect(C100App::OnlineSubmissionQueue).not_to receive(:new)

        described_class.perform_now(c100_application)
      end
    end
  end
end
