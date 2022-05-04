require 'spec_helper'

module Summary
  describe BlankPage do
    let(:c100_application) { instance_double(C100Application) }
    subject { described_class.new(c100_application) }

    describe '#template' do
      it { expect(subject.template).to eq('steps/completion/summary/show.pdf') }
    end

    describe '#name' do
      it { expect(subject.name).to be_nil }
    end

    describe '#page_number' do
      it { expect(subject.page_number).to be_nil }
    end

    describe '#raw_file_path' do
      it { expect(subject.raw_file_path).to be_nil }
    end

    describe '#sections' do
      it 'has the right sections in the right order' do
        expect(subject.sections).to match_instances_array([Partial])
      end
    end
  end
end
