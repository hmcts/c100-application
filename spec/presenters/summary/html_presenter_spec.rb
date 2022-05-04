require 'spec_helper'

describe Summary::HtmlPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#before_submit_warning' do
    let(:c100_application) { C100Application.new(submission_type: submission_type, payment_type: payment_type) }
    let(:submission_type) { nil }
    let(:payment_type) { nil }

    context 'for online submissions' do
      let(:submission_type) { SubmissionType::ONLINE }

      context 'with online payment' do
        let(:payment_type) { PaymentType::ONLINE }
        it { expect(subject.before_submit_warning).to eq('.submit_warning.online_payment_html') }
      end

      context 'without online payment' do
        let(:payment_type) { PaymentType::SELF_PAYMENT_CHEQUE }
        it { expect(subject.before_submit_warning).to eq('.submit_warning.online_html') }
      end

      context 'defaults to `online` if `payment_type` is not present' do
        it { expect(subject.before_submit_warning).to eq('.submit_warning.online_html') }
      end
    end

    context 'for print and post submissions' do
      let(:submission_type) { SubmissionType::PRINT_AND_POST }
      it { expect(subject.before_submit_warning).to eq('.submit_warning.print_and_post_html') }

      context 'defaults to `print_and_post` if `submission_type` is not present' do
        it { expect(subject.before_submit_warning).to eq('.submit_warning.print_and_post_html') }
      end
    end
  end

  describe '#submit_button_label' do
    let(:c100_application) { C100Application.new(submission_type: submission_type, payment_type: payment_type) }
    let(:submission_type) { nil }
    let(:payment_type) { nil }

    context 'for online submissions' do
      let(:submission_type) { SubmissionType::ONLINE }

      context 'with online payment' do
        let(:payment_type) { PaymentType::ONLINE }
        it { expect(subject.submit_button_label).to eq('submit_application.online_payment') }
      end

      context 'without online payment' do
        let(:payment_type) { PaymentType::SELF_PAYMENT_CHEQUE }
        it { expect(subject.submit_button_label).to eq('submit_application.online') }
      end

      context 'defaults to `online` if `payment_type` is not present' do
        it { expect(subject.submit_button_label).to eq('submit_application.online') }
      end
    end

    context 'for print and post submissions' do
      let(:submission_type) { SubmissionType::PRINT_AND_POST }
      it { expect(subject.submit_button_label).to eq('submit_application.print_and_post') }

      context 'defaults to `print_and_post` if `submission_type` is not present' do
        it { expect(subject.submit_button_label).to eq('submit_application.print_and_post') }
      end
    end
  end

  describe '#sections' do
    let(:abduction_detail) { instance_double(AbductionDetail) }
    let(:court_arrangement) { instance_double(CourtArrangement) }

    before do
      allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)

      # Abduction section
      allow(c100_application).to receive(:abduction_detail).and_return(abduction_detail)

      # Special court arrangements section
      allow(c100_application).to receive(:court_arrangement).and_return(court_arrangement)
    end

    it 'has the right sections in the right order' do
      expect(subject.sections).to match_instances_array([
        Summary::HtmlSections::OpeningQuestions,
        Summary::HtmlSections::MediationVoucherRequirement,
        Summary::HtmlSections::MiamRequirement,
        Summary::HtmlSections::MiamAttendance,
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
        Summary::HtmlSections::SolicitorDetails,
        Summary::HtmlSections::RespondentsDetails,
        Summary::HtmlSections::OtherPartiesDetails,
        Summary::HtmlSections::ChildrenResidence,
        Summary::HtmlSections::OtherCourtCases,
        Summary::HtmlSections::UrgentHearingDetails,
        Summary::HtmlSections::WithoutNoticeDetails,
        Summary::HtmlSections::InternationalElement,
        Summary::HtmlSections::ApplicationReasons,
        Summary::HtmlSections::LitigationCapacity,
        Summary::HtmlSections::AttendingCourtV2,
        Summary::HtmlSections::Submission,
        Summary::HtmlSections::Payment,
      ])
    end

    context 'when there are not yet abduction details' do
      let(:abduction_detail) { nil }

      it 'does not include the section' do
        expect(subject.sections).not_to include(Summary::HtmlSections::Abduction)
      end
    end
  end

  describe '#errors' do
    let(:errors_presenter) { instance_double(FulfilmentErrorsPresenter, errors: [Object]) }

    before do
      allow(FulfilmentErrorsPresenter).to receive(:new).with(c100_application).and_return(errors_presenter)
    end

    it 'returns application fulfilment errors' do
      expect(subject.errors).to eq([Object])
    end
  end
end
