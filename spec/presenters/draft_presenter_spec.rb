require 'spec_helper'

RSpec.describe DraftPresenter do
  subject { described_class.new(c100_application) }

  let(:c100_application) { instance_double(C100Application, c100_application_attributes) }
  let(:c100_application_attributes) {
    {
      created_at: created_at,
    }
  }

  let(:created_at) { DateTime.now }
  let(:applicant) { instance_double(Applicant, full_name: 'John Harrison') }

  before do
    travel_to Time.at(0)
  end

  describe '#expires_in' do
    context 'draft created today' do
      let(:created_at) { DateTime.now }
      it { expect(subject.expires_in).to eq('28 days') }
    end

    context 'draft created 15 days ago' do
      let(:created_at) { 15.days.ago }
      it { expect(subject.expires_in).to eq('13 days') }
    end

    context 'draft created 27 days ago' do
      let(:created_at) { 27.days.ago }
      it { expect(subject.expires_in).to eq('1 day') }
    end

    context 'draft created 28 days ago' do
      let(:created_at) { 28.days.ago }
      it { expect(subject.expires_in).to eq('Today') }
    end

    # This is to ensure even if we don't purge the draft on time for whatever reason,
    # the user will not see weird data (better to continue saying 'Today').
    context 'draft created 29 days ago' do
      let(:created_at) { 29.days.ago }
      it { expect(subject.expires_in).to eq('Today') }
    end
  end

  describe '#expires_in_class' do
    context 'draft created today' do
      let(:created_at) { DateTime.now }
      it { expect(subject.expires_in_class).to eq('') }
    end

    context 'draft created 15 days ago' do
      let(:created_at) { 15.days.ago }
      it { expect(subject.expires_in_class).to eq('') }
    end

    context 'draft created 25 days ago' do
      let(:created_at) { 25.days.ago }
      it { expect(subject.expires_in_class).to eq('expires-soon') }
    end

    context 'draft created 28 days ago' do
      let(:created_at) { 28.days.ago }
      it { expect(subject.expires_in_class).to eq('expires-today') }
    end
  end

  describe '#applicant_name' do
    before do
      allow(c100_application).to receive(:applicants).and_return(applicants)
    end

    context 'there are applicants' do
      let(:applicants) { [applicant] }
      it { expect(subject.applicant_name).to eq('John Harrison') }
    end

    context 'there are no applicants yet' do
      let(:applicants) { [] }
      it { expect(subject.applicant_name).to be_nil }
    end
  end
end
