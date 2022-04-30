require 'spec_helper'

module Summary
  describe Sections::PermissionQuestions do
    let(:c100_application) { instance_double(C100Application, relationships: relationships_scope) }
    let(:relationships_scope) { double('relationships', with_permission_data: relationships) }
    let(:relationships) { [] }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:permission_questions)
      end
    end

    describe '#answers' do
      context 'when there are no relationships with permission details' do
        it 'does not show the section' do
          expect(subject.show?).to eq(false)
        end
      end

      context 'when there are relationships with permission details' do
        let(:relationships) { [relationship1, relationship2] }

        let(:person) { instance_double(Applicant, full_name: 'Applicant Test') }
        let(:minor)  { instance_double(Child, full_name: 'Child Test') }

        let(:relationship1) {
          instance_double(
            Relationship,
            person: person,
            minor: minor,
            parental_responsibility: 'no',
            living_order: 'yes',
            amendment: nil,
            time_order: nil,
            living_arrangement: nil,
            consent: nil,
            family: nil,
            local_authority: nil,
            relative: nil,
          )
        }

        let(:relationship2) {
          instance_double(
            Relationship,
            person: person,
            minor: minor,
            parental_responsibility: 'no',
            living_order: 'no',
            amendment: 'no',
            time_order: 'yes',
            living_arrangement: nil,
            consent: nil,
            family: nil,
            local_authority: nil,
            relative: nil,
          )
        }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(2)
        end

        it 'has the correct rows in the right order' do
          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq('child_permission_living_order')
          expect(answers[0].value).to eq('yes')
          expect(answers[0].i18n_opts).to eq({ applicant_name: 'Applicant Test', child_name: 'Child Test'})

          expect(answers[1]).to be_an_instance_of(Answer)
          expect(answers[1].question).to eq('child_permission_time_order')
          expect(answers[1].value).to eq('yes')
          expect(answers[1].i18n_opts).to eq({ applicant_name: 'Applicant Test', child_name: 'Child Test'})
        end
      end
    end
  end
end
