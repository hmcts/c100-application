require 'rails_helper'

RSpec.describe PaymentIntent, type: :model do
  subject { described_class.new(c100_application: c100_application) }

  let(:c100_application) { C100Application.new }

  describe '#return_url' do
    let(:nonce) { '123456' }

    before do
      subject.save
      allow(SecureRandom).to receive(:hex).with(8).and_return(nonce)
    end

    after do
      subject.destroy
    end

    it 'sets the nonce' do
      expect {
        subject.return_url
      }.to change { subject.nonce }.from(nil).to(nonce)
    end

    it 'returns the https url with the nonce parameter' do
      Rails.configuration.force_ssl = true
      expect(
        subject.return_url
      ).to eq("https://c100.justice.uk/payments/#{subject.id}/validate?nonce=#{nonce}")
    end

    it 'returns the http url with the nonce parameter' do
      Rails.configuration.force_ssl = false
      expect(
        subject.return_url
      ).to eq("http://c100.justice.uk/payments/#{subject.id}/validate?nonce=#{nonce}")
    end
  end

  describe '#revoke_nonce!' do
    it 'sets to nil the nonce, invalidating it' do
      expect(subject).to receive(:update_column).with(:nonce, nil)
      subject.revoke_nonce!
    end
  end

  describe '#in_progress?' do
    subject { described_class.new(state: state) }

    context 'there is a finished attribute' do
      context 'and it is true' do
        let(:state) { { 'finished' => true } }

        it 'returns false' do
          expect(subject.in_progress?).to eq(false)
        end
      end

      context 'and it is false' do
        let(:state) { { 'finished' => false } }

        it 'returns true' do
          expect(subject.in_progress?).to eq(true)
        end
      end
    end

    context 'there is no finished attribute' do
      let(:state) { {} }

      it 'returns false' do
        expect(subject.in_progress?).to eq(false)
      end
    end
  end
end
