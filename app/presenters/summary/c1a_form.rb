module Summary
  class C1aForm < BasePdfForm
    def name
      'C1A'
    end

    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c1a_form),
        Sections::C1aCourtDetails.new(c100_application),
        *people_details,
        *abuse_summary,
        *abuse_details,
        *abduction_details,
        *children_other_abuse,
        *protection_orders,
        *statement_of_truth,
        *attending_court,
        Sections::C1aGettingSupport.new(c100_application),
      ].flatten.select(&:show?)
    end

    # Note: if the service gets ever translated to Welsh, then we will need
    # a translated C1A page 9 and a bit of code to know which file to use.
    def raw_file_path
      'app/assets/docs/c1a_page9.en.pdf'
    end

    private

    def people_details
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_applicants_details),
        Sections::C1aApplicantDetails.new(c100_application),
        Sections::C1aChildrenDetails.new(c100_application),
        Sections::C1aSolicitorDetails.new(c100_application),
      ]
    end

    def abuse_summary
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_abuse_details),
        Sections::C1aChildrenAbuseSummary.new(c100_application),
        Sections::C1aApplicantAbuseSummary.new(c100_application),
        Sections::C1aCourtOrders.new(c100_application),
      ]
    end

    def abuse_details
      [
        Sections::C1aConcernsSubstance.new(c100_application),
        Sections::C1aChildrenAbuseDetails.new(c100_application),
        Sections::C1aApplicantAbuseDetails.new(c100_application),
      ]
    end

    def abduction_details
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_abduction),
        Sections::C1aAbductionDetails.new(c100_application),
      ]
    end

    def children_other_abuse
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_children_other_abuse),
        Sections::C1aChildrenOtherAbuseDetails.new(c100_application),
      ]
    end

    def protection_orders
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_protection_orders),
        Sections::C1aProtectionOrders.new(c100_application),
      ]
    end

    def statement_of_truth
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_statement_of_truth),
        Sections::StatementOfTruth.new(c100_application),
      ]
    end

    def attending_court
      [
        Sections::SectionHeader.new(c100_application, name: :c1a_attending_court),
        Sections::AttendingCourtV2.new(c100_application),
      ]
    end
  end
end
