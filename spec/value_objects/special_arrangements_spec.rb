require 'rails_helper'

RSpec.describe SpecialArrangements do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        separate_waiting_rooms
        separate_entrance_exit
        protective_screens
        video_link
      ))
    end
  end
end
