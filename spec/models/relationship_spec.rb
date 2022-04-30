require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'PERMISSION_ATTRIBUTES' do
    it 'returns the expected attributes' do
      expect(
        described_class::PERMISSION_ATTRIBUTES
      ).to match_array(%i[
        parental_responsibility
        living_order
        amendment
        time_order
        living_arrangement
        consent
        family
        local_authority
        relative
      ])
    end
  end
end
