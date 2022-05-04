require 'rails_helper'

RSpec.describe C100App::ResearchSampler do
  subject { described_class.candidate?(c100_application, weight_pc) }

  let(:c100_application) { instance_double(C100Application, created_at: Time.at(seconds).to_datetime) }

  let(:seconds) { 15 }
  let(:weight_pc) { nil }

  describe '.candidate?' do
    context 'for an invalid `weight` input (nil)' do
      let(:weight_pc) { nil }
      it { expect { subject }.to raise_error(ArgumentError, 'Invalid weight ``, only values 0 to 100 allowed') }
    end

    context 'for an invalid `weight` input (string)' do
      let(:weight_pc) { '50%' }
      it { expect { subject }.to raise_error(ArgumentError, /`50%`/) }
    end

    context 'for an invalid `weight` input (over the range)' do
      let(:weight_pc) { 101 }
      it { expect { subject }.to raise_error(ArgumentError, /`101`/) }
    end

    context 'for an invalid `weight` input (below the range)' do
      let(:weight_pc) { -1 }
      it { expect { subject }.to raise_error(ArgumentError, /`-1`/) }
    end

    context 'for a 100% weight' do
      let(:weight_pc) { 100 }
      it { expect(subject).to be_truthy }
    end

    context 'for a 75% weight' do
      let(:weight_pc) { 75 }
      it { expect(subject).to be_truthy }
    end

    context 'for a 50% weight' do
      let(:weight_pc) { 50 }
      it { expect(subject).to be_truthy }
    end

    context 'for a 26% weight' do
      let(:weight_pc) { 26 }
      it { expect(subject).to be_truthy }
    end

    # Seconds go from 0 to 59, so for seconds = 15,
    # a weight of 25% will return false (sample goes 0-14)
    context 'for a 25% weight' do
      let(:weight_pc) { 25 }
      it { expect(subject).to be_falsey }
    end

    context 'for a 10% weight' do
      let(:weight_pc) { 10 }
      it { expect(subject).to be_falsey }
    end

    context 'for a 0% weight' do
      let(:weight_pc) { 0 }

      context 'and the `created_at` seconds is 0' do
        let(:seconds) { 0 }
        it { expect(subject).to be_falsey }
      end

      context 'and the `created_at` seconds is 1' do
        let(:seconds) { 1 }
        it { expect(subject).to be_falsey }
      end

      context 'and the `created_at` seconds is 59' do
        let(:seconds) { 59 }
        it { expect(subject).to be_falsey }
      end
    end

    context 'for a 100% weight' do
      let(:weight_pc) { 100 }

      context 'and the `created_at` seconds is 0' do
        let(:seconds) { 0 }
        it { expect(subject).to be_truthy }
      end

      context 'and the `created_at` seconds is 1' do
        let(:seconds) { 1 }
        it { expect(subject).to be_truthy }
      end

      context 'and the `created_at` seconds is 59' do
        let(:seconds) { 59 }
        it { expect(subject).to be_truthy }
      end
    end
  end
end
