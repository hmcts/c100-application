require 'rails_helper'

RSpec.describe Child, type: :model do
  describe '.with_special_guardianship_order?' do
    let(:scoped_query) { double('scoped_query') }

    before do
      allow(described_class).to receive(:with_special_guardianship_order).and_return(scoped_query)
    end

    it 'delegates to the scope' do
      expect(scoped_query).to receive(:any?).and_return(true)

      expect(
        described_class.with_special_guardianship_order?
      ).to eq(true)
    end
  end
end
