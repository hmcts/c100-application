require 'spec_helper'

RSpec.describe C8ConfidentialityPresenter do
  let(:person) {
    instance_double(Applicant, full_address: 'real full address', residence_history: nil, 
      email: 'mail', home_phone: '12233445566', mobile_phone: '11335566', gender: 'male',
      residence_keep_private: residence_keep_private,
      email_keep_private: email_keep_private,
      phone_keep_private: phone_keep_private,
      mobile_keep_private: mobile_keep_private,
      c100_application: c100_application_one
      )
  }
  let(:c100_application_one) { instance_double('C100Application', address_confidentiality: 'yes')}
  let(:c100_application_two) { instance_double('C100Application', address_confidentiality: 'no')}
  
  let(:person_two) {
    instance_double(Applicant, full_address: 'real full address', residence_history: nil, 
      email: 'mail', home_phone: '12233445566', mobile_phone: '11335566', gender: 'male', c100_application: c100_application_two)
  }

  let(:residence_keep_private) { 'yes' }
  let(:email_keep_private) { 'yes' }
  let(:phone_keep_private) { 'yes' }
  let(:mobile_keep_private) { 'yes' }
  
  subject { described_class.new(person) }

  describe '#to_ary' do
    it 'forwards private method' do
      x, y = subject
      expect(x).to eq(subject)
      expect(y).to be_nil
    end
  end

  describe '.replacement_answer' do
    it { expect(described_class.replacement_answer).to eq('[See C8]') }
  end

  it 'returns the original answer if it is blank/nil' do
    expect(subject.residence_history).to eq(nil)
  end

  it 'returns the replacement answer when confidentiality applies' do
    expect(subject.full_address).to eq('[See C8]')
  end

  context 'display value when not private' do
    let(:residence_keep_private) { 'no' }
    it 'returns the replacement answer when residence is set to private' do
      expect(subject.full_address).not_to eq('[See C8]')
    end

    let(:email_keep_private) { 'no' }
    it 'returns the replacement answer when email is set to private' do
      expect(subject.email).not_to eq('[See C8]')
    end

    let(:phone_keep_private) { 'no' }
    it 'returns the replacement answer when confidentiality applies' do
      expect(subject.home_phone).not_to eq('[See C8]')
    end

    let(:mobile_keep_private) { 'no' }
    it 'returns the replacement answer when confidentiality applies' do
      expect(subject.mobile_phone).not_to eq('[See C8]')
    end
  end

  context 'no private attribute present' do
    subject { described_class.new(person_two) }

    it 'returns the real value for full_address' do
      expect(subject.full_address).not_to eq('[See C8]')
    end

    it 'returns the real value for email' do
      expect(subject.email).not_to eq('[See C8]')
    end

    it 'returns the real value for home_phone' do
      expect(subject.home_phone).not_to eq('[See C8]')
    end

    it 'returns the real value for mobile_phone' do
      expect(subject.mobile_phone).not_to eq('[See C8]')
    end

    # it 'returns the replacement answer when confidentiality applies' do
    #   expect(subject.full_address).not_to eq('[See C8]')
    # end
    # it 'returns the replacement answer when confidentiality applies' do
    #   expect(subject.full_address).not_to eq('[See C8]')
    # end
  end

  it 'returns the original answer when confidentiality does not apply' do
    expect(subject.gender).to eq('male')
  end
end
