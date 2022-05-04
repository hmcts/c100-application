require 'rails_helper'

RSpec.shared_examples 'a mandatory date of birth validation' do
  context 'when date is not given' do
    let(:dob) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors.added?(:dob, :blank)).to eq(true)
    end
  end

  context 'when date is invalid' do
    let(:dob) { Date.new(18, 10, 31) } # 2-digits year (18)

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors.added?(:dob, :invalid)).to eq(true)
    end
  end

  context 'when date is too old' do
    let(:dob) { Date.new(1919, 10, 31) }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors.added?(:dob, :invalid)).to eq(true)
    end
  end

  context 'when date is in the future' do
    let(:dob) { Date.tomorrow }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors.added?(:dob, :future)).to eq(true)
    end
  end
end

RSpec.shared_examples 'a date of birth validation with unknown checkbox' do
  context 'validate presence unless `unknown` is selected' do
    it { should validate_presence_unless_unknown_of(:dob) }
  end

  context 'cannot have invalid dob' do
    let(:dob) { [nil, 0, 2, 31] }
    it 'is not valid' do
      expect(subject.valid?).to be(false)
    end
  end

  context 'cannot have invalid dob_estimate' do
    let(:dob) { nil }
    let(:dob_unknown) { true }
    let(:dob_estimate) { [nil, 0, 2, 31] }
    it 'is not valid' do
      expect(subject.valid?).to be(false)
    end
  end

  include_examples 'a mandatory date of birth validation'
end

RSpec.shared_examples 'a gender validation' do
  context 'when attribute is not given' do
    let(:gender) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[:gender]).to_not be_empty
    end
  end

  context 'when attribute value is not valid' do
    let(:gender) {'INVALID VALUE'}

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[:gender]).to_not be_empty
    end
  end
end

RSpec.shared_examples 'a previous name validation' do
  context 'when attribute is not given' do
    let(:has_previous_name) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[:has_previous_name]).to_not be_empty
    end
  end

  context 'when attribute is given and requires previous name' do
    let(:has_previous_name) { 'yes' }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the `previous_name` field' do
      expect(subject).to_not be_valid
      expect(subject.errors[:previous_name]).to_not be_empty
    end
  end

  context 'when attribute value is not valid' do
    let(:has_previous_name) {'INVALID VALUE'}

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[:has_previous_name]).to_not be_empty
    end
  end
end

RSpec.shared_examples 'a model with structured first and last names' do
  describe '#full_name' do
    subject { described_class.new(arguments) }

    let(:arguments) { { first_name: first_name, last_name: last_name } }

    let(:first_name) { nil }
    let(:last_name)  { nil }

    context 'for a person with first and last name attributes' do
      let(:first_name) { 'John' }
      let(:last_name) { 'Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end

    context 'for a person with a first_name attribute' do
      let(:first_name) { 'John Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end

    context 'for a person without a last_name attribute' do
      let(:last_name) { 'John Doe' }
      it { expect(subject.full_name).to eq('John Doe') }
    end
  end
end
