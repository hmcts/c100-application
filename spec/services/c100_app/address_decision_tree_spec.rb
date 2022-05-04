require 'rails_helper'

RSpec.describe C100App::AddressDecisionTree do
  let(:c100_application) { instance_double(C100Application) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:record)           { nil }

  subject {
    described_class.new(
      c100_application: c100_application,
      record: record,
      step_params: step_params,
      as: as,
      next_step: next_step
    )
  }

  it_behaves_like 'a decision tree'

  context 'when the step is `postcode_lookup`' do
    let(:step_params) { { 'postcode_lookup' => 'anything' } }
    let(:record) { double('Applicant', id: 123) }

    it 'goes to the address results page' do
      expect(subject.destination).to eq(controller: :results, action: :edit, id: record)
    end
  end

  context 'when the step is `address_selection`' do
    let(:step_params) { { 'address_selection' => 'anything' } }

    context 'for a record of type `Applicant`' do
      let(:record) { Applicant.new(id: 'cb211915-6b89-42b8-ac50-24a0dfa73f53') }

      it 'goes to edit the address details of the record' do
        expect(subject.destination).to eq('/steps/applicant/address_details/cb211915-6b89-42b8-ac50-24a0dfa73f53')
      end
    end

    context 'for a record of type `Respondent`' do
      let(:record) { Respondent.new(id: 'cb211915-6b89-42b8-ac50-24a0dfa73f53') }

      it 'goes to edit the address details of the record' do
        expect(subject.destination).to eq('/steps/respondent/address_details/cb211915-6b89-42b8-ac50-24a0dfa73f53')
      end
    end

    context 'for a record of type `OtherParty`' do
      let(:record) { OtherParty.new(id: 'cb211915-6b89-42b8-ac50-24a0dfa73f53') }

      it 'goes to edit the address details of the record' do
        expect(subject.destination).to eq('/steps/other_party/address_details/cb211915-6b89-42b8-ac50-24a0dfa73f53')
      end
    end
  end
end
