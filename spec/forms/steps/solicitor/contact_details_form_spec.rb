require 'spec_helper'

RSpec.describe Steps::Solicitor::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    email: email,
    phone_number: 'phone_number',
    fax_number: 'fax_number',
    dx_number: 'dx_number',
    email_provided: email_provided,
  } }

  let(:email_provided) { 'yes' }
  let(:email) { 'test@example.com' }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:phone_number) }

      context 'email validation' do
        context 'email is invalid' do
          let(:email) { 'xxx' }

          it {
            expect(subject).not_to be_valid
            expect(subject.errors.added?(:email, :invalid)).to eq(true)
          }
        end

        context 'email domain contains a typo' do
          let(:email) { 'test@gamil.com' }

          it {
            expect(subject).not_to be_valid
            expect(subject.errors.added?(:email, :typo)).to eq(true)
          }
        end
      end
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :solicitor,
                    expected_attributes: {
                      email: 'test@example.com',
                      phone_number: 'phone_number',
                      fax_number: 'fax_number',
                      dx_number: 'dx_number',
                      email_provided: GenericYesNo.new('yes'),
                    }
  end
end
