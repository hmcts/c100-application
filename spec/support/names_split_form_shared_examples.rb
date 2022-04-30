RSpec.shared_examples 'a names split CRUD form' do |form_class|
  let(:collection_name) { ActiveModel::Name.new(form_class).collection }

  let(:arguments) { {
    c100_application: c100_application,
    names_attributes: names_attributes,
    new_first_name: new_first_name,
    new_last_name: new_last_name,
  } }

  let(:c100_application) { instance_double(C100Application, collection_name => record_collection) }
  let(:record_collection) { double('record_collection', empty?: false, create: true) }

  let(:names_attributes) { {} }
  let(:new_first_name) { 'John' }
  let(:new_last_name) { 'Doe' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations on `new_first_name`' do
      context 'when there are no other records' do
        it {
          expect(record_collection).to receive(:empty?).and_return(true)
          should validate_presence_of(:new_first_name)
        }
      end

      context 'when there are existing records and last_name is present' do
        let(:new_first_name) { nil }
        let(:new_last_name) { 'Doe' }

        it {
          expect(record_collection).to receive(:empty?).and_return(false)
          should validate_presence_of(:new_first_name)
        }
      end

      context 'when there are existing records and last_name is not present' do
        let(:new_first_name) { nil }
        let(:new_last_name) { nil }

        it {
          expect(record_collection).to receive(:empty?).and_return(false)
          should_not validate_presence_of(:new_first_name)
        }
      end
    end

    context 'validations on `new_last_name`' do
      context 'when there are no other records' do
        it {
          expect(record_collection).to receive(:empty?).and_return(true)
          should validate_presence_of(:new_last_name)
        }
      end

      context 'when there are existing records and first_name is present' do
        let(:new_first_name) { 'John' }
        let(:new_last_name) { nil }

        it {
          expect(record_collection).to receive(:empty?).and_return(false)
          should validate_presence_of(:new_last_name)
        }
      end

      context 'when there are existing records and first_name is not present' do
        let(:new_first_name) { nil }
        let(:new_last_name) { nil }

        it {
          expect(record_collection).to receive(:empty?).and_return(false)
          should_not validate_presence_of(:new_last_name)
        }
      end
    end

    context 'when form is valid' do
      context 'adding new names' do
        let(:new_first_name) { 'Gareth' }
        let(:new_last_name) { 'Doe' }

        it 'it creates a new child with the provided first and last name' do
          expect(record_collection).to receive(:create).with(
            first_name: 'Gareth', last_name: 'Doe'
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'if the new name is blank, ignore it' do
        let(:new_first_name) { '' }
        let(:new_last_name) { '' }

        it 'it creates a new child with the provided name' do
          expect(record_collection).not_to receive(:create)
          expect(subject.save).to be(true)
        end
      end

      context 'updating existing names' do
        let(:new_first_name) { nil }
        let(:new_last_name) { nil }

        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', 'first_name' => 'Paul', 'last_name' => 'ABC'},
            '1' => {'id' => 'uuid2', 'first_name' => 'Alex', 'last_name' => 'XYZ'}
          }
        }

        it 'it updates the names of the people' do
          expect(record_collection).to receive(:update).with(
            'uuid1', {'id' => 'uuid1', 'first_name' => 'Paul', 'last_name' => 'ABC'}
          ).and_return(true)

          expect(record_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', 'first_name' => 'Alex', 'last_name' => 'XYZ'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'ignore blank attributes when updating' do
        let(:new_first_name) { nil }
        let(:new_last_name) { nil }

        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', 'first_name' => '', 'last_name' => 'ABC'},
            '1' => {'id' => 'uuid2', 'first_name' => 'Alex', 'last_name' => ''},
            '2' => {'id' => 'uuid3', 'first_name' => 'John', 'last_name' => 'Doe'},
          }
        }

        it 'it updates the names of the people' do
          expect(record_collection).not_to receive(:update).with(
            'uuid1', {'id' => 'uuid1', 'first_name' => '', 'last_name' => 'ABC'}
          )

          expect(record_collection).not_to receive(:update).with(
            'uuid2', {'id' => 'uuid2', 'first_name' => 'Alex', 'last_name' => ''}
          )

          expect(record_collection).to receive(:update).with(
            'uuid3', {'id' => 'uuid3', 'first_name' => 'John', 'last_name' => 'Doe'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
