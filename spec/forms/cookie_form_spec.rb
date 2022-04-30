require 'spec_helper'

describe CookieForm do
  subject(:form) { described_class.new }
  describe 'usage=' do
    it 'stores the value' do
      form.usage = true
      expect(form.usage).to be true
    end
  end
end
