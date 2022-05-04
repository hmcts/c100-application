require 'rails_helper'

RSpec.describe Applicant, type: :model do
  it_behaves_like 'a model with structured first and last names'
  it_behaves_like 'a model with structured address details'

  describe '.under_age?' do
    subject { c100_application.applicants }

    context 'there are not applicants' do
      let(:c100_application) { C100Application.new }
      it { expect(subject.under_age?).to eq(false) }
    end

    context 'there are not under age applicants' do
      let(:c100_application) { C100Application.create(applicants: [app1]) }
      let(:app1) { Applicant.new(under_age: false) }

      it { expect(subject.under_age?).to eq(false) }
    end

    context 'there is at least 1 under age applicant' do
      let(:c100_application) { C100Application.create(applicants: [app1, app2]) }

      let(:app1) { Applicant.new(under_age: true) }
      let(:app2) { Applicant.new(under_age: false) }

      it { expect(subject.under_age?).to eq(true) }
    end
  end
end
