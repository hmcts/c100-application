RSpec.shared_examples 'a value object form' do |options|
  context 'when no c100_application is associated with the form' do
    let(:c100_application) { nil }
    let(options[:attribute_name]) { options[:example_value] }

    it 'raises an error' do
      expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
    end
  end

  context 'when attribute is not given' do
    let(options[:attribute_name]) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end

  context 'when attribute value is not valid' do
    let(options[:attribute_name]) { 'INVALID VALUE' }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end
end

RSpec.shared_examples 'a yes-no question form' do |options|
  let(:question_attribute) { options[:attribute_name] }
  let(:answer_value) { 'yes' }

  let(:reset_when_yes) { options.fetch(:reset_when_yes, []) }
  let(:reset_when_no)  { options.fetch(:reset_when_no,  []) }

  let(:linked_attribute)  { options[:linked_attribute] }
  let(:linked_attribute_value) { 'details' }
  let(:linked_attributes) { linked_attribute ? { linked_attribute => linked_attribute_value } : {} }

  let(:arguments) {
    {
      c100_application: c100_application,
      question_attribute => answer_value
    }.merge(linked_attributes)
  }

  let(:c100_application) { instance_double(C100Application) }

  # Used for forms including the concern `HasOneAssociationForm`
  # Refer to `spec/forms/steps/attending_court/intermediary_form_spec.rb` for an example if this
  let(:association_name) { options[:association_name] }
  let(:association) { association_name ? instance_double(association_name.to_s.classify) : c100_application }

  subject { described_class.new(arguments) }

  def attributes_to_reset(attrs)
    Hash[attrs.collect {|att| [att, nil]}]
  end

  describe 'validations on field presence' do
    it { should validate_presence_of(question_attribute, :inclusion) }

    if options[:linked_attribute]
      context 'when answer is yes, validates presence of linked attribute' do
        let(:answer_value) { 'yes' }
        it { should validate_presence_of(linked_attribute) }
      end

      context 'when answer is no, does not validate presence of linked attribute' do
        let(:answer_value) { 'no' }
        it { should_not validate_presence_of(linked_attribute) }
      end
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { described_class.new(arguments).save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when there is a c100_application associated with the form' do
      if options[:association_name]
        before do
          allow(c100_application).to receive(association_name).and_return(association)
        end
      end

      context 'when answer is `yes`' do
        let(:answer_value) { 'yes' }
        let(:additional_attributes) { attributes_to_reset(reset_when_yes).merge(linked_attributes) }

        it 'saves the record' do
          expect(association).to receive(:update).with(
            { options[:attribute_name] => GenericYesNo::YES }.merge(additional_attributes)
          ).and_return(true)
          expect(described_class.new(arguments).save).to be(true)
        end
      end

      context 'when answer is `no`' do
        let(:answer_value) { 'no' }
        let(:additional_attributes) { attributes_to_reset(reset_when_no) }

        it 'saves the record' do
          expect(association).to receive(:update).with(
            hash_including({ options[:attribute_name] => GenericYesNo::NO }.merge(additional_attributes))
          ).and_return(true)
          expect(described_class.new(arguments).save).to be(true)
        end
      end
    end
  end
end

RSpec.shared_examples 'a permission yes-no question form' do |options|
  include_examples 'a yes-no question form', options do
    let(:relationship) { instance_double(Relationship) }
    let(:association) { relationship }

    let(:arguments) {
      {
        record: relationship,
        c100_application: c100_application,
        question_attribute => answer_value
      }.merge(linked_attributes)
    }

    describe '#question_name' do
      let(:attributes_mock) { {a: '1', b: '2', c: '3'} }

      # mutant kill
      it 'picks the first attribute in case there are more than one' do
        expect(subject).to receive(:attributes).and_return(attributes_mock)
        expect(subject.question_name).to eq(:a)
      end

      it 'is equal to the yes-no attribute' do
        expect(subject.question_name).to eq(question_attribute)
      end
    end
  end
end

RSpec.shared_examples 'a has-one-association form' do |options|
  let(:association_name) { options[:association_name] }
  let(:expected_attributes) { options[:expected_attributes] }
  let(:build_method_name) { "build_#{association_name}".to_sym }

  let(:association_double) { double(association_name) }

  context 'when no c100_application is associated with the form' do
    let(:c100_application) { nil }

    it 'raises an error' do
      expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
    end
  end

  context 'for valid details' do
    context 'when record does not exist' do
      before do
        allow(c100_application).to receive(association_name).and_return(nil)
      end

      it 'creates the record if it does not exist' do
        expect(c100_application).to receive(build_method_name).and_return(association_double)

        expect(association_double).to receive(:update).with(
          expected_attributes
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end

    context 'when record already exists' do
      before do
        allow(c100_application).to receive(association_name).and_return(association_double)
      end

      it 'updates the record if it already exists' do
        expect(c100_application).not_to receive(build_method_name)

        expect(association_double).to receive(:update).with(
          expected_attributes
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
