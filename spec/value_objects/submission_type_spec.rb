require 'rails_helper'

RSpec.describe SubmissionType do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        online
        print_and_post
      ))
    end
  end
end
