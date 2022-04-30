require 'spec_helper'

RSpec.describe Steps::Application::UrgentHearingDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    urgent_hearing_details: urgent_hearing_details,
    urgent_hearing_when: urgent_hearing_when,
    urgent_hearing_short_notice: urgent_hearing_short_notice,
    urgent_hearing_short_notice_details: urgent_hearing_short_notice_details,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:urgent_hearing_details) { 'details' }
  let(:urgent_hearing_when) { 'next week' }
  let(:urgent_hearing_short_notice) { 'no' }
  let(:urgent_hearing_short_notice_details) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:urgent_hearing_details) }
      it { should validate_presence_of(:urgent_hearing_when) }
      it { should validate_presence_of(:urgent_hearing_short_notice, :inclusion) }

      context 'when `urgent_hearing_short_notice` is yes' do
        let(:urgent_hearing_short_notice) { 'yes' }
        it { should validate_presence_of(:urgent_hearing_short_notice_details) }
      end

      context 'when `urgent_hearing_short_notice` is no' do
        let(:urgent_hearing_short_notice) { 'no' }
        it { should_not validate_presence_of(:urgent_hearing_short_notice_details) }
      end
    end

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          urgent_hearing_details: 'details',
          urgent_hearing_when: 'next week',
          urgent_hearing_short_notice: GenericYesNo::NO,
          urgent_hearing_short_notice_details: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
