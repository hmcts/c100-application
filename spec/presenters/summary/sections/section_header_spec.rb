require 'spec_helper'

module Summary
  describe Sections::SectionHeader do
    let(:c100_application) { instance_double(C100Application) }
    subject { described_class.new(c100_application, name: :custom_name) }

    describe '#name' do
      it { expect(subject.name).to eq(:custom_name) }
    end

    describe '#to_partial_path' do
      it { expect(subject.to_partial_path).to eq('steps/completion/shared/section_header') }
    end

    describe '#show?' do
      it { expect(subject.show?).to eq(true) }
    end
  end
end
