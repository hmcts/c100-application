require 'spec_helper'

RSpec.describe C8CollectionProxy do
  let(:c100_application) {
    instance_double(C100Application, confidentiality_enabled?: confidentiality_enabled)
  }
  let(:collection) { %w(item1 item2) }

  subject { described_class.new(c100_application, collection) }

  context 'confidentiality is disabled' do
    let(:confidentiality_enabled) { false }

    it 'returns the original collection' do
      expect(subject).to match_instances_array(
        [String, String]
      )
    end
  end

  context 'confidentiality is enabled' do
    let(:confidentiality_enabled) { true }

    it 'decorates the collection' do
      expect(subject).to match_instances_array(
        [C8ConfidentialityPresenter, C8ConfidentialityPresenter]
      )
    end
  end
end
