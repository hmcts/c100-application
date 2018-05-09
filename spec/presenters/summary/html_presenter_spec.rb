require 'spec_helper'

describe Summary::HtmlPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#sections' do
    before do
      allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)

      # Abduction section
      allow(c100_application).to receive(:abduction_detail).and_return(AbductionDetail.new)
    end

    it 'has the right sections in the right order' do
      expect(subject.sections).to match_instances_array([
        Summary::HtmlSections::ChildProtectionCases,
        Summary::HtmlSections::MiamRequirement,
        Summary::HtmlSections::MiamExemptions,
        Summary::HtmlSections::SafetyConcerns,
        Summary::HtmlSections::Abduction,
        Summary::HtmlSections::ChildrenAbuseDetails,
        Summary::HtmlSections::ApplicantAbuseDetails,
        Summary::HtmlSections::CourtOrders,
        Summary::HtmlSections::SafetyContact,
        Summary::HtmlSections::NatureOfApplication,
        Summary::HtmlSections::Alternatives,
        Summary::HtmlSections::ChildrenDetails,
        Summary::HtmlSections::ChildrenFurtherInformation,
        Summary::HtmlSections::OtherChildrenDetails,
        Summary::HtmlSections::ApplicantsDetails,
        Summary::HtmlSections::RespondentsDetails,
        Summary::HtmlSections::OtherPartiesDetails,
        Summary::HtmlSections::OtherCourtCases,
        Summary::HtmlSections::WithoutNoticeDetails,
        Summary::HtmlSections::InternationalElement,
      ])
    end
  end
end
