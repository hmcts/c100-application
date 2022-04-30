require 'spec_helper'

module Summary
  describe HtmlSections::ChildrenResidence do
    let(:c100_application) { instance_double(C100Application, children: [child]) }

    let(:child) { instance_double(Child, to_param: 'uuid-555', full_name: 'Child Test', child_residence: child_residence) }
    let(:child_residence) { instance_double(ChildResidence, person_ids: %w(uuid-123 uuid-456)) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:children_residence) }
    end

    describe '#answers' do
      let(:people_find_result) { double('Resulset') }
      let(:full_names) { %w(John Peter) }

      before do
        allow(Person).to receive(:where).with(id: %w(uuid-123 uuid-456)).and_return(people_find_result)
        allow(people_find_result).to receive(:map).and_return(full_names)
      end

      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:child_residence)
        expect(answers[0].change_path).to eq('/steps/children/residence/uuid-555')
        expect(answers[0].i18n_opts).to eq({child_name: 'Child Test'})
        expect(answers[0].value).to eq('John and Peter')
      end
    end
  end
end
