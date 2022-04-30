require 'rails_helper'

RSpec.describe C100App::<%= task_name.camelize %>DecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  pending 'Write specs for <%= task_name.camelize %>DecisionTree!'

  # TODO: The below can be uncommented and serves as a starting point

  # context 'when the step is `user_type`' do
  #   let(:step_params) { { user_type: 'anything' } }
  #
  #   context 'and the answer is `themself`' do
  #     let(:c100_application) { instance_double(C100Application, user_type: UserType::THEMSELF) }
  #     it { is_expected.to have_destination(:user_type, :edit) }
  #   end
  #
  #   context 'and the answer is `representative`' do
  #     let(:c100_application) { instance_double(C100Application, user_type: UserType::REPRESENTATIVE) }
  #     it { is_expected.to have_destination(:user_type, :edit) }
  #   end
  # end
end
