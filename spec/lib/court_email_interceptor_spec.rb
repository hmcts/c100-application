require 'rails_helper'

describe CourtEmailInterceptor do
  let(:message) {
    Mail::Message.new(
      subject: 'Test email',
      from: ['from@example.com'],
      to: ['recipient@example.com'],
      reply_to: reply_to,
    )
  }
  let(:reply_to) { nil }

  def deliver_email!
    described_class.delivering_email(message)
  end

  context 'whitelisted handlers' do
    it { expect(described_class::DELIVERY_WHITELIST).to eq(%w[NotifyMailer ReceiptMailer]) }
  end

  context 'for a whitelisted delivery handler' do
    before do
      message.delivery_handler = NotifyMailer
    end

    it 'let the email be sent untouched' do
      expect(described_class).not_to receive(:intercept_email!)
      deliver_email!
    end
  end

  context 'for a non-whitelisted delivery handler' do
    before do
      message.delivery_handler = 'whatever'
    end

    it 'should be intercepted and the subject changed' do
      deliver_email!
      expect(message.subject).to eq('Test email | (Original recipient: recipient@example.com)')
    end

    it 'should perform deliveries' do
      expect(message.perform_deliveries).to eq(true)
    end

    context 'message with reply-to' do
      let(:reply_to) { ['replies@example.com'] }

      it 'changes the recipient to be the `REPLY-TO` address' do
        deliver_email!
        expect(message.to).to eq(reply_to)
      end
    end

    context 'message without reply-to' do
      let(:reply_to) { nil }

      it 'changes the recipient to be the `FROM` address' do
        deliver_email!
        expect(message.to).to eq(['from@example.com'])
      end
    end
  end
end