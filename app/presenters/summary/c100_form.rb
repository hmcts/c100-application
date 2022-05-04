module Summary
  class C100Form < BasePdfForm
    def name
      'C100'
    end

    def sections
      [
        summary_sections,
        children_form_sections,
        miam_sections,
        application_reasons_sections,
        urgent_and_without_notice_sections,
        other_court_cases_section,
        international_element_sections,
        litigation_and_assistance_sections,
        people_sections,
        statement_of_truth_and_payment,
      ].flatten.select(&:show?)
    end

    private

    def summary_sections
      [
        Sections::FormHeader.new(c100_application, name: :c100_form),
        Sections::C100CourtDetails.new(c100_application),
        Sections::HelpWithFees.new(c100_application),
        Sections::ApplicantRespondent.new(c100_application),
        Sections::NatureOfApplication.new(c100_application),
        Sections::RiskConcerns.new(c100_application),
        Sections::AdditionalInformation.new(c100_application)
      ]
    end

    def children_form_sections
      [
        Sections::SectionHeader.new(c100_application, name: :children),
        Sections::ChildrenDetails.new(c100_application),
        Sections::ChildrenRelationships.new(c100_application),
        Sections::ChildrenResidence.new(c100_application),
        Sections::PermissionQuestions.new(c100_application),
      ]
    end

    def miam_sections
      [
        Sections::SectionHeader.new(c100_application, name: :miam_requirement),
        Sections::MiamRequirement.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :miam_exemptions),
        Sections::MiamExemptions.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :mediator_certification),
        Sections::MediatorCertification.new(c100_application),
      ]
    end

    def application_reasons_sections
      [
        Sections::SectionHeader.new(c100_application, name: :application_reasons),
        Sections::ApplicationReasons.new(c100_application),
      ]
    end

    def urgent_and_without_notice_sections
      [
        Sections::SectionHeader.new(c100_application, name: :urgent_and_without_notice),
        Sections::UrgentHearing.new(c100_application),
        Sections::WithoutNoticeHearing.new(c100_application),
      ]
    end

    def other_court_cases_section
      [
        Sections::SectionHeader.new(c100_application, name: :other_court_cases),
        Sections::OtherCourtCases.new(c100_application),
      ]
    end

    def international_element_sections
      [
        Sections::SectionHeader.new(c100_application, name: :international_element),
        Sections::InternationalElement.new(c100_application)
      ]
    end

    def litigation_and_assistance_sections
      [
        Sections::SectionHeader.new(c100_application, name: :litigation_capacity),
        Sections::LitigationCapacity.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :attending_court),
        Sections::AttendingCourtV2.new(c100_application),
      ]
    end

    def people_sections
      [
        Sections::SectionHeader.new(c100_application, name: :applicants_details),
        Sections::ApplicantsDetails.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :respondents_details),
        Sections::RespondentsDetails.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :other_parties_details),
        Sections::OtherPartiesDetails.new(c100_application),
        Sections::OtherChildrenDetails.new(c100_application),
        Sections::SectionHeader.new(c100_application, name: :solicitor_details),
        Sections::SolicitorDetails.new(c100_application),
      ]
    end

    def statement_of_truth_and_payment
      [
        Sections::SectionHeader.new(c100_application, name: :statement_of_truth),
        Sections::StatementOfTruth.new(c100_application),
        Sections::CourtFee.new(c100_application),
        Sections::ProcessingDetails.new(c100_application),
      ]
    end
  end
end
