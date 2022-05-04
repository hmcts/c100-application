require 'spec_helper'

module Summary
  describe Sections::AdditionalInformation do
    let(:c100_application) { double(C100Application).as_null_object }
    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    before do
      allow(c100_application).to receive(:court_arrangement).and_return(nil)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:additional_information)
      end
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(7)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:asking_for_permission)
        expect(c100_application).to have_received(:permission_sought) # The values of this are tested separated

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:urgent_or_without_notice)
        expect(answers[1].value).to eq(GenericYesNo::NO) # The values of this are tested separated

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:children_previous_proceedings)
        expect(c100_application).to have_received(:children_previous_proceedings)

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:consent_order)
        expect(c100_application).to have_received(:consent_order)

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:international_element_case)
        expect(answers[4].value).to eq(GenericYesNo::NO) # The values of this are tested separated

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:litigation_capacity_case)
        expect(c100_application).to have_received(:reduced_litigation_capacity)

        expect(answers[6]).to be_an_instance_of(Answer)
        expect(answers[6].question).to eq(:language_assistance)
        expect(answers[6].value).to eq(GenericYesNo::NO) # The values of this are tested separated
      end
    end

    describe 'asking for permission' do
      before do
        expect(c100_application).to receive(:permission_sought).and_return(permission_sought)
      end

      context 'permission sought is `nil`' do
        let(:permission_sought) { nil }

        it 'returns the default value' do
          expect(answers[0].value).to eq(:not_required)
        end
      end

      context 'permission sought is not `nil`' do
        let(:permission_sought) { 'yes' }

        it 'returns the question value' do
          expect(answers[0].value).to eq('yes')
        end
      end
    end

    describe '`urgent_or_without_notice_value` answer values' do
      before do
        expect(c100_application).to receive(:urgent_hearing).and_return(urgent_hearing)
        expect(c100_application).to receive(:without_notice)
      end

      context 'at least one question was answered as `YES`' do
        let(:urgent_hearing) { 'yes' }

        it 'returns the question value' do
          expect(answers[1].value).to eq('yes')
        end
      end

      context 'there are no questions answered with `YES`' do
        let(:urgent_hearing) { 'no' }

        it 'returns the default value for the answer' do
          expect(answers[1].value).to eq(GenericYesNo::NO)
        end
      end
    end

    describe '`international_element_case` answer values' do
      before do
        expect(c100_application).to receive(:international_resident).and_return(international_resident)
        expect(c100_application).to receive(:international_jurisdiction)
        expect(c100_application).to receive(:international_request)
      end

      context 'at least one question was answered as `YES`' do
        let(:international_resident) { 'yes' }

        it 'returns the question value' do
          expect(answers[4].value).to eq('yes')
        end
      end

      context 'there are no questions answered with `YES`' do
        let(:international_resident) { 'no' }

        it 'returns the default value for the answer' do
          expect(answers[4].value).to eq(GenericYesNo::NO)
        end
      end
    end

    describe '`language_assistance` answer values' do
      before do
        allow(c100_application).to receive(:court_arrangement).and_return(court_arrangement)
      end

      let(:court_arrangement) { nil }

      context 'when we have a `court_arrangement` record' do
        let(:court_arrangement) { instance_double(CourtArrangement, language_options: language_options) }

        context 'at least one check box was selected' do
          let(:language_options) { ['language_interpreter'] }

          it 'returns a `YES` value' do
            expect(answers[6].value).to eq(GenericYesNo::YES)
          end
        end

        context 'no check box was selected' do
          let(:language_options) { [] }

          it 'returns the default value' do
            expect(answers[6].value).to eq(GenericYesNo::NO)
          end
        end
      end

      context 'when we do not have a `court_arrangement` record' do
        it 'returns the default value' do
          expect(answers[6].value).to eq(GenericYesNo::NO)
        end
      end
    end
  end
end
