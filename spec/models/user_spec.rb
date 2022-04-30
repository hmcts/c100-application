require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#last_sign_in_at' do
    specify { expect(described_class.column_names).to include('last_sign_in_at') }
  end

  describe '#current_sign_in_at' do
    specify { expect(described_class.column_names).to include('current_sign_in_at') }
  end

  describe '.purge!' do
    let(:finder_double) { double.as_null_object }

    before do
      travel_to Time.now
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        'current_sign_in_at <= :date OR (created_at <= :date AND current_sign_in_at IS NULL)', date: 30.days.ago
      ).and_return(finder_double)

      described_class.purge!(30.days.ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(finder_double)
      expect(finder_double).to receive(:destroy_all)

      described_class.purge!(30.days.ago)
    end
  end

  describe 'email validation' do
    subject { described_class.new(password: 'password', email: email) }

    context 'validate if not present' do
      let(:email) { nil }

      it {
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:email, :blank)).to eq(true)
      }
    end

    context 'validate if malformed' do
      let(:email) { 'xxx' }

      it {
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:email, :invalid)).to eq(true)
      }
    end

    context 'custom value casting' do
      #
      # This is just a quick test to ensure the `NormalisedEmailType` casting is being used.
      # A more in-deep test of all possible unicode substitutions can be found in:
      # spec/attributes/normalised_email_type_spec.rb
      #
      let(:email) { "test\u2032ing@hyphened\u2010domain.com" }

      it 'should replace common unicode equivalent characters' do
        expect(subject.email).to eq("test\u0027ing@hyphened\u002ddomain.com")
      end
    end
  end

  describe '#send_devise_notification' do
    let(:devise_mailer) { double('devise_mailer') }
    let(:mailer) { double('mailer') }

    before do
      allow(subject).to receive(:devise_mailer).and_return(devise_mailer)
    end

    it 'uses `deliver_later`' do
      expect(devise_mailer).to receive(:send).with(:test_email, subject, :hello).and_return(mailer)
      expect(mailer).to receive(:deliver_later)

      subject.send_devise_notification(:test_email, :hello)
    end
  end
end
