require 'spec_helper'

module Summary
  describe C8Form do
    let(:c100_application) { instance_double(C100Application) }
    subject { described_class.new(c100_application) }

    describe '#name' do
      it { expect(subject.name).to eq('C8') }
    end

    describe '#template' do
      it { expect(subject.template).to eq('steps/completion/summary/show.pdf') }
    end

    describe '#raw_file_path' do
      it { expect(subject.raw_file_path).to be_nil }
    end

    describe '#sections' do
      before do
        allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)
      end

      it 'has the right sections in the right order' do
        expect(subject.sections).to match_instances_array([
          Sections::FormHeader,
          Sections::C8CourtDetails,
          Partial,
          Sections::C8ApplicantsDetails,
          Sections::C8OtherPartiesDetails,
        ])
      end
    end
  end
end
