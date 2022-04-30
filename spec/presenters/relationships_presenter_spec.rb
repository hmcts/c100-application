require 'spec_helper'

RSpec.describe RelationshipsPresenter do
  let(:c100_application) {
    instance_double(
      C100Application,
      confidentiality_enabled?: confidentiality_enabled,
      minors: minors,
      relationships: relationships,
    )
  }

  let(:confidentiality_enabled) { false }

  let(:minors) { [] }
  let(:relationships) { double('relationships') }
  let(:child_relationship) { double(Relationship) }

  subject { described_class.new(c100_application) }

  describe '#relationship_to_children' do
    let(:person) { instance_double(Person, relationships: relationships) }

    before do
      allow(relationships).to receive(:where).with(minor: minors, person: person).and_return([child_relationship])

      allow(child_relationship).to receive(:relation).and_return('father')
      allow(child_relationship).to receive(:minor).and_return(double(full_name: 'Child name'))
      allow(child_relationship).to receive(:person).and_return(double(full_name: 'Person name'))
    end

    context 'showing the person name' do
      it 'returns a string describing the relationships' do
        expect(subject.relationship_to_children(person, show_person_name: true)).to eq('Person name - Father to Child name')
      end

      context 'for more than one relationship' do
        before do
          allow(relationships).to receive(:where).with(minor: minors, person: person).and_return(
            [child_relationship, child_relationship]
          )
        end

        it 'joins the lines with "\n" (`simple_format` will format this on the PDF)' do
          expect(
            subject.relationship_to_children(person, show_person_name: true)
          ).to eq("Person name - Father to Child name\nPerson name - Father to Child name")
        end
      end
    end

    context 'hiding the person name' do
      it 'returns a string describing the relationships' do
        expect(subject.relationship_to_children(person, show_person_name: false)).to eq('Father to Child name')
      end
    end

    context 'for `other` relationship' do
      before do
        allow(child_relationship).to receive(:relation).and_return('other')
        allow(child_relationship).to receive(:relation_other_value).and_return('A friend')
      end

      context 'showing the person name' do
        it 'returns a string describing the relationships' do
          expect(subject.relationship_to_children(person, show_person_name: true)).to eq('Person name - A friend to Child name')
        end
      end

      context 'hiding the person name' do
        it 'returns a string describing the relationships' do
          expect(subject.relationship_to_children(person, show_person_name: false)).to eq('A friend to Child name')
        end
      end
    end

    context 'for a collection under C8 confidentiality' do
      let(:person) { OtherParty.new }

      context 'and confidentiality is enabled' do
        let(:confidentiality_enabled) { true }

        it 'returns the C8 replacement string' do
          expect(subject.relationship_to_children(person)).to eq('[See C8]')
        end

        context 'but the bypass is activated' do
          it 'returns the relationship details' do
            expect(subject.relationship_to_children(person, bypass_c8: true)).to eq('Person name - Father to Child name')
          end
        end
      end

      context 'and confidentiality is disabled' do
        let(:confidentiality_enabled) { false }

        it 'returns the relationship details' do
          expect(subject.relationship_to_children(person)).to eq('Person name - Father to Child name')
        end
      end
    end
  end
end
