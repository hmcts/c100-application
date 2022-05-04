require 'spec_helper'

RSpec.describe Steps::Application::WithoutNoticeDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    without_notice_details: without_notice_details,
    without_notice_frustrate: without_notice_frustrate,
    without_notice_frustrate_details: without_notice_frustrate_details,
    without_notice_impossible: without_notice_impossible,
    without_notice_impossible_details: without_notice_impossible_details
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:without_notice_details) { 'details' }
  let(:without_notice_frustrate) { 'no' }
  let(:without_notice_frustrate_details) { nil }
  let(:without_notice_impossible) { 'no' }
  let(:without_notice_impossible_details) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:without_notice_details) }
      it { should validate_presence_of(:without_notice_frustrate, :inclusion) }
      it { should validate_presence_of(:without_notice_impossible, :inclusion) }

      context 'when `without_notice_frustrate` is yes' do
        let(:without_notice_frustrate) { 'yes' }
        it { should validate_presence_of(:without_notice_frustrate_details) }
      end

      context 'when `without_notice_frustrate` is no' do
        let(:without_notice_frustrate) { 'no' }
        it { should_not validate_presence_of(:without_notice_frustrate_details) }
      end

      context 'when `without_notice_impossible` is yes' do
        let(:without_notice_impossible) { 'yes' }
        it { should validate_presence_of(:without_notice_impossible_details) }
      end

      context 'when `without_notice_impossible` is no' do
        let(:without_notice_impossible) { 'no' }
        it { should_not validate_presence_of(:without_notice_impossible_details) }
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
          without_notice_details: 'details',
          without_notice_frustrate: GenericYesNo::NO,
          without_notice_frustrate_details: nil,
          without_notice_impossible: GenericYesNo::NO,
          without_notice_impossible_details: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
