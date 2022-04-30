require 'spec_helper'

RSpec.describe ValidPaymentsArray do
  subject { described_class.new(c100_application) }

  let(:c100_application) { C100Application.new(attributes) }
  let(:attributes) { {
    has_solicitor: has_solicitor,
    submission_type: submission_type,
  } }

  let(:has_solicitor) { nil }
  let(:submission_type) { nil }

  let(:common_choices) { described_class::COMMON_CHOICES }

  describe '#pay_blocklist' do
    it 'returns the blocked slugs' do
      expect(
        subject.pay_blocklist
      ).to match_array(%w(
        blocklisted-slug-example
      ))
    end
  end

  describe '#include?' do
    context 'for an included string' do
      it 'returns true' do
        expect(subject.include?(PaymentType::HELP_WITH_FEES.to_s)).to eq(true)
      end
    end

    context 'for an included value-object' do
      it 'returns true' do
        expect(subject.include?(PaymentType::HELP_WITH_FEES)).to eq(true)
      end
    end

    context 'for an invalid string' do
      it 'returns true' do
        expect(subject.include?('foobar')).to eq(false)
      end
    end

    context 'for a nil value' do
      it 'returns false' do
        expect(subject.include?(nil)).to eq(false)
      end
    end
  end

  context 'for an online submission' do
    let(:submission_type) { SubmissionType::ONLINE.to_s }

    let(:court_double) { Court.build(court_data) }
    let(:court_data) {
      {
        'name' => 'Test court',
        'email' => 'court@example.com',
        'address' => 'Court address',
        'county_location_code' => 123,
        'slug' => court_slug,
        'gbs' => court_gbs,
      }
    }

    let(:court_gbs) { 'XYZ' }
    let(:court_slug) { 'west-london-family-court' }

    before do
      allow(c100_application).to receive(:court).and_return(court_double)
    end

    context 'for a court slug included in the blocklist' do
      let(:court_slug) { 'blocklisted-slug-example' }

      it 'does not include the online option' do
        expect(subject).not_to include(PaymentType::ONLINE)
      end

      it 'includes the pay by phone option' do
        expect(subject).to include(PaymentType::HELP_WITH_FEES)
      end
    end

    context 'for a court without GBS code' do
      let(:court_gbs) { Court::UNKNOWN_GBS }

      it 'does not include the online option' do
        expect(subject).not_to include(PaymentType::ONLINE)
      end

      it 'includes the pay by phone option' do
        expect(subject).to include(PaymentType::HELP_WITH_FEES)
      end
    end

    context 'with solicitor' do
      let(:has_solicitor) { 'yes' }

      it 'has valid payment choices' do
        expect(subject).to match_array([PaymentType::HELP_WITH_FEES, PaymentType::SOLICITOR, PaymentType::ONLINE])
      end
    end

    context 'without solicitor' do
      let(:has_solicitor) { 'no' }

      it 'has valid payment choices' do
        expect(subject).to match_array([PaymentType::HELP_WITH_FEES, PaymentType::ONLINE])
      end
    end

    context 'unavailable payment type' do
      it 'cheque' do
        expect(subject).to_not include(PaymentType::SELF_PAYMENT_CHEQUE)
      end
    end
  end

  context 'for a print and post submission' do
    let(:submission_type) { SubmissionType::PRINT_AND_POST.to_s }

    it 'does not include the pay by phone option' do
      expect(subject).not_to include(PaymentType::SELF_PAYMENT_CARD)
    end

    context 'with solicitor' do
      let(:has_solicitor) { 'yes' }

      it 'has valid payment choices' do
        expect(subject).to match_array(common_choices + [PaymentType::SOLICITOR])
      end
    end

    context 'without solicitor' do
      let(:has_solicitor) { 'no' }

      it 'has valid payment choices' do
        expect(subject).to match_array(common_choices)
      end
    end

    context 'unavailable payment type' do
      it 'online' do
        expect(subject).to_not include(PaymentType::ONLINE)
      end
    end
  end
end
