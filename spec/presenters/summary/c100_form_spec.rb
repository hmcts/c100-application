require 'spec_helper'

module Summary
  describe C100Form do
    let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }
    let(:court_arrangement) { instance_double(CourtArrangement) }

    subject { described_class.new(c100_application) }

    describe '#name' do
      it { expect(subject.name).to eq('C100') }
    end

    describe '#template' do
      it { expect(subject.template).to eq('steps/completion/summary/show.pdf') }
    end

    describe '#raw_file_path' do
      it { expect(subject.raw_file_path).to be_nil }
    end

    describe '#sections' do
      before do
        allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)
      end

      it 'has the right sections in the right order' do
        expect(subject.sections).to match_instances_array([
          Sections::FormHeader,
          Sections::C100CourtDetails,
          Sections::HelpWithFees,
          Sections::ApplicantRespondent,
          Sections::NatureOfApplication,
          Sections::RiskConcerns,
          Sections::AdditionalInformation,
          Sections::SectionHeader,
          Sections::ChildrenDetails,
          Sections::ChildrenRelationships,
          Sections::ChildrenResidence,
          Sections::PermissionQuestions,
          Sections::SectionHeader,
          Sections::MiamRequirement,
          Sections::SectionHeader,
          Sections::MiamExemptions,
          Sections::SectionHeader,
          Sections::MediatorCertification,
          Sections::SectionHeader,
          Sections::ApplicationReasons,
          Sections::SectionHeader,
          Sections::UrgentHearing,
          Sections::WithoutNoticeHearing,
          Sections::SectionHeader,
          Sections::OtherCourtCases,
          Sections::SectionHeader,
          Sections::InternationalElement,
          Sections::SectionHeader,
          Sections::LitigationCapacity,
          Sections::SectionHeader,
          Sections::AttendingCourtV2,
          Sections::SectionHeader,
          Sections::ApplicantsDetails,
          Sections::SectionHeader,
          Sections::RespondentsDetails,
          Sections::SectionHeader,
          Sections::OtherPartiesDetails,
          Sections::OtherChildrenDetails,
          Sections::SectionHeader,
          Sections::SolicitorDetails,
          Sections::SectionHeader,
          Sections::StatementOfTruth,
          Sections::CourtFee,
          Sections::ProcessingDetails,
        ])
      end
    end
  end
end
