require 'rails_helper'

describe CourtEmailInterceptor do
  let(:message) {
    Mail::Message.new(
      from: ['from@example.com'],
      to: ['recipient@example.com'],
    )
  }

  def deliver_email!
    described_class.delivering_email(message)
  end

  context 'whitelisted handlers' do
    it { expect(described_class::DELIVERY_WHITELIST).to eq(%w[NotifyMailer ReportsMailer]) }
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

    it 'changes the recipient to be the `FROM` address' do
      deliver_email!
      expect(message.to).to eq(['from@example.com'])
    end

    it 'should perform deliveries' do
      expect(message.perform_deliveries).to eq(true)
    end
  end
end
